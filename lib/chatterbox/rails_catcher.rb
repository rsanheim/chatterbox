module Chatterbox
  module RailsCatcher
    
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
      options = { :exception => exception }
      options.merge!(:request => request) if self.respond_to?(:request)
      Chatterbox::ExceptionNotification.handle(options)
      Chatterbox.logger.debug { "Chatterbox handing exception #{exception} off to normal rescue handling" }
      rescue_action_in_public_without_chatterbox(exception)
    end
    
    private
    
    
  end
  
end