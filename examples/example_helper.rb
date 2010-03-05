begin
  # Require the preresolved locked set of gems.
  require File.expand_path('../.bundle/environment', __FILE__)
rescue LoadError
  # Fallback on doing the resolve at runtime.
  require "rubygems"
  require "bundler"
  Bundler.setup
end

# Now require the default group and the development group
Bundler.require(:default, :development)

LogBuddy.init
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'lib/chatterbox'

def not_in_editor?
  !(ENV.has_key?('TM_MODE') || ENV.has_key?('EMACS') || ENV.has_key?('VIM'))
end

Micronaut.configure do |c|
  c.mock_with :mocha
  c.color_enabled = not_in_editor?
  c.filter_run :focused => true
  c.alias_example_to :fit, :focused => true
  c.enable_controller_support :behaviour => { :describes => lambda { |dt| dt < ::ActionController::Base } }
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
