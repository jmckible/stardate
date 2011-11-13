set :application, 'stardate'
set :deploy_to,   "/data/#{application}"

role :app, 'mckible.com'
role :web, 'mckible.com' 
role :db,  'mckible.com', :primary => true

default_run_options[:pty]   = true
set :ssh_options, {:forward_agent => true}

set :repository,        'git@github.com:jmckible/stardate.git'
set :scm,               'git'
set :user,              'jmckible'
set :runner,            'jmckible'
set :branch,            'master'
set :deploy_via,        :remote_cache
set :git_shallow_clone, 1

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles=>:app, :except=>{ :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after 'deploy:update_code', 'symlink_configs'
task :symlink_configs, :roles=>:app do
  run <<-CMD
    cd #{release_path} &&
    ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml
  CMD
end