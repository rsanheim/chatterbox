$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require "rubygems"
gem 'actionmailer'#, '~> 2.3'
gem 'actionpack'#, "~> 2.3"
gem 'rails'#, '~> 2.3'
require 'action_controller'
require 'action_mailer'
require 'active_support'
require 'rails'
require 'rails/version'

puts "Specs running against Rails version: #{Rails::VERSION::STRING}"

$on_rails_3 = Rails::VERSION::MAJOR >= 3
if $on_rails_3
  gem "rspec-rails"
  require "rspec/rails"
else
  gem "rspec-rails23"
  require "rspec-rails23"
end

require 'rspec'
require 'mocha'
require 'log_buddy'
LogBuddy.init
require 'chatterbox'

RSpec.configure do |config|
  config.mock_with :mocha
  config.formatter = :documentation
  config.color_enabled = true
  config.alias_example_to :fit, :focused => true
  config.filter_run :options => { :focused => true }
  config.run_all_when_everything_filtered = true
  if $on_rails_3
    config.include RSpec::Rails::ControllerExampleGroup, :behaviour => { :describes => lambda { |dt| dt < ::ActionController::Base } }
  else
    config.enable_controller_support :behaviour => { :describes => lambda { |dt| dt < ::ActionController::Base } }
  end
end

def valid_options(overrides = {})
  options = { 
    :summary => "here is a message",
    :config => { 
      :to => "joe@example.com", 
      :from => "someone@here.com" 
    }
  }.merge(overrides)
end
