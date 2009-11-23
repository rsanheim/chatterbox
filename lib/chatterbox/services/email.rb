require 'chatterbox'
require 'chatterbox/services/email/mailer'

module Chatterbox::Services
  class Email
    attr_reader :options
    @default_configuration = {}

    def self.default_configuration
      @default_configuration
    end
    
    def self.configure(config_options)
      @default_configuration = config_options
    end
    
    def self.deliver(options = {})
      new(options).deliver
    end
    
    def initialize(options = {})
      @options = options
      merge_configs
      merge_message
      validate_options
    end
    
    def deliver
      Mailer.deliver_message(options)
    end
    
    private
    
    def merge_message
      if @options[:message]
        @options.merge!(@options[:message])
      end
    end
    
    def merge_configs
      @options[:config] ||= {}
      @options[:config] = self.class.default_configuration.merge(options[:config])
    end
    
    def validate_options
      require_summary
      
      require_config
      require_config_keys(:to, :from)
    end
    
    def require_config
      raise(ArgumentError, "Must configure with a :config or set default_configuration") unless options.key?(:config)
    end
    
    def require_config_keys(*keys)
      Array(keys).each do |key|
        raise(ArgumentError, "Must provide #{key.inspect} in the :config - you provided:\n#{options.inspect}") unless options[:config].key?(key)
      end
    end
    
    def require_summary
      raise(ArgumentError, "Must provide a :summary for your message - you provided:\n#{options.inspect}") unless options.key?(:summary)
    end
  end
end