module Chatterbox
  module ExceptionNotification
    
    def handle(arg)
      hsh = normalize_to_hash(arg)
      notification = extract_details(hsh)
    end

    def normalize_to_hash(arg)
      case
      when Exception === arg then           { :exception => arg }
      when arg.respond_to?(:to_hash) then   arg.to_hash
      when arg.respond_to?(:to_s) then      { :summary => arg.to_s }
      end
    end

    def extract_details(hsh)
      options = Chatterbox::ExceptionNotification::Extracter.wrap(hsh)
      options = Chatterbox::ExceptionNotification::RailsExtracter.wrap(options)
      options = Chatterbox::ExceptionNotification::Presenter.render(options)
      options
    end
    
    extend self
    
  end
end

require 'chatterbox/exception_notification/extracter'
require 'chatterbox/exception_notification/rails_extracter'
require 'chatterbox/exception_notification/presenter'