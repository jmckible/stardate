# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.order                      = 'random'
  config.fixture_path               = "#{::Rails.root}/spec/fixtures"
  config.global_fixtures            = :all
  config.use_transactional_fixtures = true

  config.render_views
  config.infer_spec_type_from_file_location!

  def cookie(name, value)
    @request.cookies[name.to_s] = CGI::Cookie.new name.to_s, value.to_s
  end

  def running(&block)
    lambda &block
  end

  def login_as(name)
    @current_user = users(name)
    @request.session[:user_id] = @current_user.id
    cookie :user_id, @current_user.id
    cookie :password_hash, @current_user.password_hash
  end

end
