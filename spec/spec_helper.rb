# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  
  config.global_fixtures = :all

  def running(&block)
    lambda &block
  end

end


# Always integrate_views in controllers
module Spec
  module Rails
    module Example
      class ControllerExampleGroup
        module ControllerInstanceMethods
          def integrate_views?
            true
          end
        end
      end
    end
  end
end