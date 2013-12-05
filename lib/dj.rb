require 'rubygems'
require 'active_record'
require 'nppes'
require 'pry'
require 'pry-byebug'
require 'active_record'

require_relative 'env'

module Nppes
  def self.logger
      @@logger = Logger.new(File.join(__dir__,'delayed_job.log'))
  end
end


#Nppes.background_init
Nppes::Jobs::IniterJob.new.perform
#Nppes::Jobs::SearcherJob.new((Nppes.get_time_period if continious))
