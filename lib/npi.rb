require 'sinatra/base'
require 'sinatra/config_file'
require 'sinatra'
require 'json'
require 'active_record'
require 'yaml'
require 'nppes'
require 'byebug'
require_relative 'env'


class Speciality < ActiveRecord::Base
  has_many :provider_specialities
end

class Npi < Sinatra::Base
  register Sinatra::ConfigFile
  config_file 'config.yml'
  set :port, 7678
  set :server, ['webrick']

  configure do
    use BetterErrors::Middleware
    BetterErrors.application_root = __dir__
  end

def get_data(npi_id)

  @npi = Nppes::NpIdentifier.includes(:np_addresses, :np_licenses).where(npi: npi_id).first
    if @npi
      if (pro_address = @npi.np_addresses.first)
        @address = {
          address1: pro_address.address1,
          address2: pro_address.address2,
          city: pro_address.city,
          state: pro_address.decoded_state,
          country: pro_address.decoded_country,
          zip: pro_address.zip,
          phone: pro_address.phone,
        }
      end

      if (license = @npi.np_licenses.first)
        @speciality = {
          speciality_id: Speciality.where(name: license.decoded_speciality).first.try(:id),
          license_number: license.license_number,
          state: license.decoded_state,
          country: 'United States'
        }
      end

      @name = {
        first_name: @npi.first_name,
        middle_name: @npi.middle_name,
        last_name: @npi.last_name,
        prefix: @npi.prefix,
        suffix: @npi.suffix
      }
    end
end

def npi_view_render(npi)
if npi.np_addresses.present?
  address="<p class='text-center'>#{npi.np_addresses.first.to_s}</p>"
else
  address=""
end
"<p>Success</p><div><p class='text-center'>#{npi.to_s}</p>#{address}</div><p>If its look like your profile, please continue. Otherwise, re-enter npi.</p>"
end

  get '/npi/:npi' do
    content_type :json
    get_data(params['npi'])
    {npi: @npi.present?,npi_result: npi_view_render(@npi), address: @address, speciality: @speciality, user_name: @name}.to_json
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end

