set :application, 'shepherd-rest-api'
set :scm, "git"
set :scm_verbose, true
set :repo_url, "git@github.com:aboma/shepherd-rest-api.git"
set :repository, "git@github.com:aboma/shepherd-rest-api.git"
#set :branch, "master"
#set :branch do
#  `git tag`.split("\n").last
#end

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
#
#server "162.243.11.113", :app, :web, :db, :primary => true
set :user, "deploy" # The server's user for deploys
set :deploy_to, '/var/www/shepherd-rest-api'
set :use_sudo, false

set :deploy_via, :remote_cache

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

set :linked_files, %w{config/database.yml config/puma.rb}
set :linked_dirs, %w{tmp/puma}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end

# These Puma tasks rely on the puma Ubuntu Upstart tools, part of 
# the Puma jungle tool, found in the puma distribution tool directory. The Upstart
# config file must be edited to allow user sudo-less ability to start and stop jobs
namespace :puma do
  desc "Start Puma Manager"
  task :start_manager do
    on roles(:app) do
      info "Starting puma manager"
      execute "start puma-manager"
    end
  end

  desc "Stopping Puma Manager"
  task :stop_manager do
    on roles(:app) do
      info "Stopping puma manager"
      execute "stop puma-manager"
    end
  end

  desc "Register Puma application"
  task :add do
    on roles(:app) do
      info "Registering puma app #{current_path} with puma manager"
      execute "grep -w '#{current_path}' /etc/puma.conf || printf \"#{current_path}\\n\" >> /etc/puma.conf"
    end
  end

  task :remove do
    on roles(:app) do
      #TODO
    end
  end

  desc "Start puma instance for this application"
  task :start do
    on roles(:app) do 
      info "Starting puma app #{current_path}"
      execute "start puma app=#{current_path}"
    end
  end

  desc "Stop puma instance for this application"
  task :stop do
    on roles(:app) do
      info "Stopping puma app #{current_path}"
      execute "stop puma app=#{current_path}"
    end
  end

  desc "Restart puma instance for this application"
  task :restart do
    on roles(:app) do
      info "Restarting puma app #{current_path}"
      execute "restart puma app=#{current_path}"
    end
  end

  desc "Show status of puma for this application"
  task :status do
    on roles(:app) do
      execute "status puma app=#{current_path}"
    end
  end
end

after "deploy:starting", "puma:stop"
after "deploy:finished", "puma:start"
