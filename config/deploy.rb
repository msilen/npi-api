# config valid only for Capistrano 3.1
lock '3.2.0'
#require 'byebug'

set :application, 'npiapi'
set :repo_url, 'git@github.com:msilen/npi-api.git'
set :branch, 'from_apps'


set :rvm_type, :system

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/vagrant/npiapi'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{lib/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do
  desc 'start appilcation'
  task :start do
    on roles(:app) do
      within current_path do
        execute :bundle, "exec unicorn -c unicorn.rb -D -l 0.0.0.0:7678 "
      end
    end
  end

  task :stop do
    on roles(:app) do
      within current_path do
        execute :kill,"-QUIT `cat tmp/pids/unicorn.pid`"
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app) do
      within current_path do
        execute :kill,"-HUP `cat tmp/pids/unicorn.pid`" #TODO: USR2 ? kill other master
      end
    end
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
