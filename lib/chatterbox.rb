require 'active_support'

module Chatterbox
  # Send a notification with Chatterbox
  # Returns the message itself
  #
  # <tt>message</tt> is an options hash that allows the following options:
  # 
  # :summary - The summary of the message - required.  If your service only supports
  #   'short' notifications, like Twitter, this is generally what you should send.
  # :body - The body of the message - this may not be used if the service you are using 
  #   doesn't support 'bodies' -- for example, Twitter.
  # :config - The configuration settings for the different services the notification should use.
  #   See the individual services you are using for what configuration options should be used.
  def notify(message)
    publish_notice(message)
    message
  end
  
  def publish_notice(message)
    Publishers.publishers.each { |p| p.call(message.with_indifferent_access) }
  end
  
  # Deprecated version of #notify
  def handle_notice(message)
    warning = "Chatterbox#handle_notice is deprecated and will be removed from Chatterbox 1.0. Call Chatterbox#notify instead."
    deprecate(warning, caller)
    notify(message)
  end
  
  def deprecate(message, callstack)
    ActiveSupport::Deprecation.warn(message, callstack)
  end
  
  # Retrieve (lazily loaded) logger; defaults to a nil Logger
  def logger
    @logger ||= Logger.new(nil)
  end
  
  # Set default logger for Chatterbox to use; mostly for development and debugging purposes
  def logger=(logger)
    @logger = logger
  end
  
  # Register a service for sending notifications
  #
  # ===== Example:
  #
  #   Chatterbox::Publishers.register do |notice|
  #     Chatterbox::Services::Email.deliver(notice)
  #    end
  def register(&blk)
    Publishers.register(&blk)
  end
  
  extend self
  
  module Publishers
    def publishers
      @publishers ||= []
    end
      
    def register(&blk)
      Chatterbox.logger.debug { "Registering publisher: #{blk}"}
      publishers << blk
      blk
    end
    
    def clear!
      @publishers = []
    end

    extend self
  end
end

require "chatterbox/services"
require "chatterbox/version"