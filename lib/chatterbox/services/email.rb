require 'chatterbox'
require 'chatterbox/services/email/mailer'

module Chatterbox::Services
  class Email
    attr_reader :options
    # Return default configuration - defaults to empty hash
    def self.default_configuration
      @default_configuration ||= {}
    end

    # Configure Email service with default options
    def self.configure(config_options)
      @default_configuration = config_options.with_indifferent_access
    end
    
    # Deliver the a notification via email
    #
    # ==== Options
    #
    # * :summary - The subject of the message - required.
    # * :body - The body of the email - if none provided, you will just send an email with a blank body.
    # * :config - A sub-hash of configuration options.  
    #   Optional if you have configured a default configuration with #configure.
    #   Config can contain any of the following options, all of which are pretty self explanatory:
    #
    #     :to
    #     :from
    #     :content_type
    #     :reply_to
    #     :bcc
    #     :cc
    def self.deliver(options = {})
      new(options).deliver
    end
    
    # Creates a new Email service with provided options.
    # See Email::deliver for the valid options
    def initialize(options = {})
      @options = options
      merge_configs
      merge_message
      validate_options
    end
    
    # Deliver a notificaiton -- normally you should just use the class level method Email::deliver
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