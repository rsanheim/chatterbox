require 'chatterbox'
require 'chatterbox/mailer'

module Chatterbox
  class Email
    
    def self.deliver(options = {})
      new(options).deliver
    end
    
    attr_reader :options
    
    def initialize(options = {})
      @options = options
      validate_options
    end
    
    def deliver
      Mailer.deliver_message(options)
    end
    
    private
    
    def validate_options
      require_message
      require_message_keys(:summary)
      
      require_config
      require_config_keys(:to, :from)
    end
    
    def require_message
      raise(ArgumentError, "Must configure with a :message") unless options.key?(:message)
    end
    
    def require_config
      raise(ArgumentError, "Must configure with a :config") unless options.key?(:config)
    end
    
    def require_config_keys(*keys)
      Array(keys).each do |key|
        raise(ArgumentError, "Must provide #{key.inspect} in the :config") unless options[:config].key?(key)
      end
    end
    
    def require_message_keys(*keys)
      Array(keys).each do |key|
        raise(ArgumentError, "Must provide #{key.inspect} in the :message") unless options[:message].key?(key)
      end
    end
  end
end