require 'ostruct'

module Chatterbox
  module ExceptionNotification

    # Handle the exception
    # Accepts either an exception, a hash, or an object that responds to to_s
    #   Exceptions are passed through like normal
    #   Hashes can have an :exception => exception in them, which will result in 
    #     the same treatment as a literal exception passed 
    #   Objects are simply treated as a 'summary' message were an exception may not be necessary
    def handle(args)
      hsh = normalize_to_hash(args)
      return if on_ignore_list?(hsh[:exception])
      hsh = Extracter.wrap(hsh)
      hsh = RailsExtracter.wrap(hsh)
      hsh = Presenter.render(hsh)
      Chatterbox.notify(hsh)
    end

    def normalize_to_hash(args)
      case
      when Exception === args then           { :exception => args }
      when args.respond_to?(:to_hash) then   args.to_hash
      when args.respond_to?(:to_s) then      { :summary => args.to_s }
      end
    end
    
    def on_ignore_list?(exception)
      configuration.ignore.include?(exception.class) || 
      configuration.ignore.include?(exception.class.to_s)
    end

    def configuration
      @configuration ||= OpenStruct.new(:ignore => default_ignored_exceptions)
    end
    
    # Configure ExceptionNotification
    # ex:
    #   Chatterbox::ExceptionNotification.configure do |config|
    #      config.ignore << MyOwnExceptionToIgnore
    #   end
    #
    #
    def configure
      yield(configuration)
    end
    
    # Default exceptions that ExceptionNotification will ignore
    def default_ignored_exceptions
      ['ActiveRecord::RecordNotFound', 'ActionController::RoutingError',
       'ActionController::InvalidAuthenticityToken', 'ActionController::UnknownAction',
       'CGI::Session::CookieStore::TamperedWithCookie' ]
    end
    
    extend self
    
  end
end

require 'chatterbox/exception_notification/extracter'
require 'chatterbox/exception_notification/rails_extracter'
require 'chatterbox/exception_notification/presenter'