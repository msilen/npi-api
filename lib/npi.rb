require 'sinatra/base'
require 'sinatra/config_file'
require 'json'

class Npi < Sinatra::Base
  register Sinatra::ConfigFile
  config_file 'config.yml'

  get '/npi/:npi' do
    content_type :json
    { exists: true }.to_json
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
