require File.join(File.dirname(__FILE__), *%w[chatterbox notification])
require File.join(File.dirname(__FILE__), *%w[consumers])

module Chatterbox

  def handle_notice(message)
    notice = Notification.new(message).notice
    publish_notice(notice)
  end

  def publish_notice(notice)
    Publishers.publishers.each { |p| p.call(notice) }
  end
  
  def logger
    @logger ||= rails_default_logger || Logger.new(STDOUT)
  end
  
  def logger=(logger)
    @logger = logger
  end
  
  def rails_default_logger
    defined?(RAILS_DEFAULT_LOGGER) ? RAILS_DEFAULT_LOGGER : nil
  end
  
  extend self
  
  module Publishers

    class << self

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

    end
    
  end
  
end

