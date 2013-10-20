require 'sinatra/base'
require 'sinatra/config_file'
require 'json'
require 'active_record'
require 'yaml'
require 'pry'

dbconfig = YAML::load(File.open(File.join(File.dirname(__FILE__), 'database.yml')))

ActiveRecord::Base.establish_connection(dbconfig['npi'])

class NpIdentifier < ActiveRecord::Base  
  has_many :np_licenses, dependent: :destroy    
  has_many :np_addresses, dependent: :destroy    
end

class Npi < Sinatra::Base
  register Sinatra::ConfigFile
  config_file 'config.yml'
  set :port, 7678

  get '/npi/:npi' do
    content_type :json
    result=NpIdentifier.find_by_npi params['npi']
    if result
      result.to_json
    else
     ({error: "Identifier not found"}).to_json
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
