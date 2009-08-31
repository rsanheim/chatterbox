module Chatterbox
  
  class Notification
    
    attr_reader :message
    
    def initialize(message = nil)
      @message = message
    end
    
    def notice
      hash = normalize_message_to_hash(message)
      hash = exception_to_notice(hash)
      default_info.merge(hash)
    end
    
    def normalize_message_to_hash(message)
      case
      when Exception === message
        { :exception => message }
      when message.respond_to?(:to_hash)
        message.to_hash
      when message.respond_to?(:to_s)
        string_to_notice(message.to_s)
      end
    end
    
    def default_info
      default_info     = {
        :summary       => "N/A",
        :environment   => env,
        :ruby_version  => ruby_version,
        :ruby_platform => ruby_platform
      }
      default_info = add_ruby_info(default_info)
      default_info = add_rails_info(default_info) if rails_configuration
      default_info
    end
    
    def string_to_notice(message)
      { :summary => message }
    end
    
    def exception_to_notice(hash)
      return hash unless hash.key?(:exception)
      exception = hash[:exception]
      {
        :summary => "#{exception.class.name}: #{exception.message}",
        :error_class   => exception.class.name,
        :error_message => exception.message,
        :backtrace     => exception.backtrace,
      }.merge(hash)
    end
    
    def add_rails_info(data)
      data.merge({
        :rails_env => rails_configuration.env,
        :rails_root => rails_configuration.root,
        :rails_version => rails_configuration.version
      })
    end
    
    def add_ruby_info(data)
      data.merge({
        :ruby_version  => ruby_version,
        :ruby_platform => ruby_platform
      })
    end

    def ruby_version
      RUBY_VERSION
    end
    
    def ruby_platform
      RUBY_PLATFORM
    end
    
    def env
      ENV.to_hash
    end
    
    def rails_configuration
      defined?(Rails) && Rails
    end
    
  end
end
