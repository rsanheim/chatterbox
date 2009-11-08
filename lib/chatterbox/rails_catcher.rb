require 'ostruct'

module Chatterbox

  module RailsCatcher
    delegate :logger, :to => Chatterbox
    
    def self.configuration
      @configuration ||= OpenStruct.new(:ignore => [])
    end
    
    def self.configure
      yield(configuration)
    end
    
    def self.included(base)
      if base.instance_methods.map(&:to_s).include? 'rescue_action_in_public' and !base.instance_methods.map(&:to_s).include? 'rescue_action_in_public_without_chatterbox'
        base.send(:alias_method, :rescue_action_in_public_without_chatterbox, :rescue_action_in_public)
        base.send(:alias_method, :rescue_action_in_public, :rescue_action_in_public_with_chatterbox)
        base.hide_action(:rescue_action_in_public_with_chatterbox, :rescue_action_in_public_without_chatterbox)
      end
    end
    
    # Overrides the rescue_action method in ActionController::Base, but does not inhibit
    # any custom processing that is defined with Rails 2's exception helpers.
    def rescue_action_in_public_with_chatterbox(exception)
      logger.debug { "#{log_prefix} caught exception #{exception} - about to handle" }
      unless on_ignore_list?(exception)
        Chatterbox.handle_notice(extract_exception_details(exception))
      end
      logger.debug { "#{log_prefix} handing exception #{exception} off to normal rescue handling" }
      rescue_action_in_public_without_chatterbox(exception)
    end
    
    private
    
    def log_prefix
      "#{self.class}#rescue_action_in_public_with_chatterbox:"
    end
    
    def on_ignore_list?(exception)
      RailsCatcher.configuration.ignore.include?(exception.class)
    end
    
    def extract_exception_details(exception)
      options = { :exception => exception, :request => request }
      options = Chatterbox::ExceptionNotification::Extracter.wrap(options)
      options = Chatterbox::ExceptionNotification::RailsExtracter.wrap(options)
      options = Chatterbox::ExceptionNotification::Presenter.render(options)
      options
    end
    
  end
  
end