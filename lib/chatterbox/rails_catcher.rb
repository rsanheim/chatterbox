require 'ostruct'

module Chatterbox

  module RailsCatcher
    
    def self.default_ignored_exceptions
      ['ActiveRecord::RecordNotFound', 'ActionController::RoutingError',
       'ActionController::InvalidAuthenticityToken', 'ActionController::UnknownAction',
       'CGI::Session::CookieStore::TamperedWithCookie' ]
    end
    
    def self.configuration
      @configuration ||= OpenStruct.new(:ignore => default_ignored_exceptions)
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
      Chatterbox.logger.debug { "Chatterbox caught exception #{exception} - about to handle" }
      unless on_ignore_list?(exception)
        options = { :exception => exception }
        options.merge!(:request => request) if self.respond_to?(:request)
        Chatterbox::ExceptionNotification.handle(options)
        # Chatterbox.handle_notice(extract_exception_details(exception))
      end
      Chatterbox.logger.debug { "Chatterbox handing exception #{exception} off to normal rescue handling" }
      rescue_action_in_public_without_chatterbox(exception)
    end
    
    private
    
    def on_ignore_list?(exception)
      Chatterbox::RailsCatcher.configuration.ignore.include?(exception.class) || 
      Chatterbox::RailsCatcher.configuration.ignore.include?(exception.class.to_s)
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