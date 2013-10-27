require 'rubygems'
require 'active_record'
require 'nppes'
require 'pry'
require 'pry-byebug'
require 'active_record'

require_relative 'env'

#Nppes.background_init
#Nppes::Jobs::IniterJob.new.perform
binding.pry
continious=false
Nppes::Jobs::SearcherJob.new((Nppes.get_time_period if continious))
