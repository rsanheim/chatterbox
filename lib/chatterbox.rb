require 'active_support'

module Chatterbox
  def notify(message)
    publish_notice(message)
    message
  end
  
  def publish_notice(message)
    Publishers.publishers.each { |p| p.call(message.with_indifferent_access) }
  end
  
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