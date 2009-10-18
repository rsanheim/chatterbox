module Chatterbox

  def handle_notice(message)
    publish_notice(message)
    message
  end
  
  alias_method :notify, :handle_notice

  def publish_notice(message)
    Publishers.publishers.each { |p| p.call(message) }
  end
  
  def logger
    @logger ||= Logger.new(nil)
  end
  
  def logger=(logger)
    @logger = logger
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

