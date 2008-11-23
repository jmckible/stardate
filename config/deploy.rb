set :application, 'stardate'
set :deploy_to,   "/var/#{application}"

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

after 'deploy:update_code', 'symlink_configs'
task :symlink_configs, :roles=>:app do
  run <<-CMD
    cd #{release_path} &&
    ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml
  CMD
end

after 'symlink_configs', 'migrate'
task :migrate, :roles=>:db, :only=>{:primary=>true} do
  rake           = fetch :rake,           'rake'
  rails_env      = fetch :rails_env,      'production'
  migrate_env    = fetch :migrate_env,    ''
  migrate_target = fetch :migrate_target, :latest

  directory = case migrate_target.to_sym
    when :current then current_path
    when :latest  then current_release
    else raise ArgumentError, "unknown migration target #{migrate_target.inspect}"
  end

  run "cd #{directory}; #{rake} RAILS_ENV=#{rails_env} #{migrate_env} #{migrate_env} db:migrate"
end

namespace :deploy do
  desc 'Restarting passenger with restart.txt'
  task :restart, :roles=>:app, :except=>{:no_release=>true} do
    run "touch #{current_path}/tmp/restart.txt"
  end
 
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles=>:app do ; end
  end
end