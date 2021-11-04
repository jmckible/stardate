if %w[development test].include? Rails.env
  require 'rubocop/rake_task'
  require 'haml_lint/rake_task'

  RuboCop::RakeTask.new do |task|
    task.requires << 'rubocop-rails'
  end

  HamlLint::RakeTask.new do |t|
    t.files = ['app/views/**/*.haml']
  end

  task(:default).clear
  task default: %w[rspec rubocop haml_lint eslint]
end

task :rspec do
  sh 'rspec spec/'
end

task :eslint do
  sh './node_modules/.bin/eslint ./app/javascript'
end
