require_relative 'lib/env'
require 'pry'
require 'pry-byebug'
require 'delayed_job_active_record'
namespace :db do
  desc "Migrate the database"
  task :migrate do
    ActiveRecord::Migrator.migrate('lib/db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
  end
end

#require File.expand_path('../my_main_file', __FILE__)

namespace :jobs do

  @worker_options={destroy_failed_jobs: false, sleep_delay: 1, max_attempts: 100, max_run_time: 200000.seconds, read_ahead: 10, default_queue_name: 'default', delay_jobs: true, quiet: false}
  desc "Clear the delayed_job queue."
  task :clear do
    Delayed::Job.delete_all
  end

  desc "Start a delayed_job worker."
  task :work do
    Delayed::Worker.new(@worker_options).start
  end

  desc "Start a delayed_job worker and exit when all available jobs are complete."
  task :workoff do
    Delayed::Worker.max_run_time = 200000.seconds
    Delayed::Worker.new(@worker_options.merge({:exit_on_complete => true})).start
  end

  task :environment_options do
  @worker_options={destroy_failed_jobs: false, sleep_delay: 1, max_attempts: 100, max_run_time: 20.hours, read_ahead: 10, default_queue_name: 'default', delay_jobs: true, quiet: false}
  desc "Clear the delayed_job queue."
    #@worker_options = {
      #:min_priority => ENV['MIN_PRIORITY'],
      #:max_priority => ENV['MAX_PRIORITY'],
      #:queues => (ENV['QUEUES'] || ENV['QUEUE'] || '').split(','),
      #:quiet => false
    #}
  end
end


require 'rake'
require 'nppes'


namespace :nppes do
  def already_run?
    `ps aux | grep delayed_job | awk '{print $11}'`.lines.detect {|line| line == "delayed_job\n"}.present?
  end

  def has_pid?
    Dir[Rails.root.join('tmp', 'pids','delayed_job*.pid')].present?
  end

  def run_env
    unless already_run?
      STDOUT << "Run env ...\n"
      Rake::Task['nppes:start_background_env'].invoke
    end
  end

  desc 'Finish all background processes'
  task :stop_all do
    `kill -9 $(ps aux | less | grep delayed_job |  awk '{print $2}')`
    Dir[Rails.root.join('tmp', 'pids','delayed_job*.pid')].each {|file| File.delete file}
  end

  desc 'Start background env. Please specify RAILS_ENV. By default used "development" env'
  task :start_background_env do
    #`cd #{Rails.root} | RAILS_ENV=#{ENV['RAILS_ENV'] || 'development'} bin/delayed_job start`
    Rake::Task['jobs:work'].invoke
  end

  desc 'Stop background env'
  task :stop_background_env do
    `cd #{Rails.root} | RAILS_ENV=#{ENV['RAILS_ENV'] || 'development'} bin/delayed_job stop`
  end


  desc 'Run init base by info'
  task :init_base do
Delayed::Worker.max_run_time=40.hours
    run_env
module Nppes
def self.logger
@@logger = Logger.new(File.join(__dir__,'delayed_job.log'))  
end
end
    Nppes.background_init
  end

  desc 'Run auto update'
Delayed::Worker.max_run_time=40.hours
  task :auto_update => :environment do
    run_env
    Nppes.background_update(true)
  end

  desc 'Run update once'
  task :update do
    run_env
module Nppes
def self.logger
@@logger = Logger.new(File.join(__dir__,'delayed_job.log'))  
end
end
    Nppes.background_update
  end
end

