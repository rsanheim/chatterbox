require 'active_support'

module Chatterbox
  def handle_notice(message)
    publish_notice(message)
    message
  end
  
  alias_method :notify, :handle_notice

  def publish_notice(message)
    Publishers.publishers.each { |p| p.call(message.with_indifferent_access) }
  end
  
  def logger
    @logger ||= Logger.new(nil)
  end
  
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