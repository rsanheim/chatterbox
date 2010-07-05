$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require "rubygems"
gem 'actionpack', "~> 2.3"
gem 'actionmailer', "~> 2.3"
gem "rspec-rails23"
require "rspec-rails23"
require 'action_controller'
require 'rspec'
require 'mocha'
require 'log_buddy'
LogBuddy.init
require 'chatterbox'

Rspec.configure do |config|
  config.mock_with :mocha
  config.formatter = :documentation
  config.color_enabled = true
  config.alias_example_to :fit, :focused => true
  config.filter_run :options => { :focused => true }
  config.run_all_when_everything_filtered = true
  config.enable_controller_support :behaviour => { :describes => lambda { |dt| dt < ::ActionController::Base } }
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
