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
    def rescue_action_in_public_with_chatterbox exception
      Chatterbox.logger.debug { "#{self.class}#rescue_action_in_public_with_chatterbox: caught exception #{exception} - about to handle"}
      options = extract_exception_details(exception)
      Chatterbox.handle_notice(options)
      Chatterbox.logger.debug { "#{self.class}#rescue_action_in_public_with_chatterbox: handing exception #{exception} off to normal rescue handling"}
      
      rescue_action_in_public_without_chatterbox(exception)
    end
    
    def extract_exception_details(exception)
      options = { :exception => exception }
      options = Chatterbox::ExceptionNotification::Filter.wrap(options)
      options = Chatterbox::ExceptionNotification::RailsExtracter.wrap(options)
      options = Chatterbox::ExceptionNotification::Presenter.render(options)
      options
    end
    
  end
  
end