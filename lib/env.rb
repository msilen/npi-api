require 'rubygems'
require 'yaml'
require 'active_record'
dbconfig = YAML::load(File.open(File.join(File.dirname(__FILE__), 'database.yml')))
ActiveRecord::Base.establish_connection(dbconfig['npi'])
