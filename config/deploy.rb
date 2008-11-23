set :application, 'stardate'
set :deploy_to,   "/var/#{application}"

set :domain, 'mckible.com'
server domain, :app, :web
role :db, domain, :primary=>true

default_run_options[:pty]   = true
ssh_options[:forward_agent] = true

set :repository,        'git@github.com:jmckible/stardate.git'
set :scm,               'git'
set :user,              'jmckible'
set :branch,            'master'
set :deploy_via,        :remote_cache
set :git_shallow_clone, 1

namespace :passenger do
  desc 'Restart Application'
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after :deploy, 'passenger:restart'
