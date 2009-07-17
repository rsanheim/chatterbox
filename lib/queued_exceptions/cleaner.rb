module QueuedExceptions
  
  class Cleaner
    
    attr_reader :exception
    
    def initialize(exception = RuntimeError.new)
      @exception = exception
    end
    
    def clean
      data = case @exception
      when Exception 
        {
          :error_class   => exception.class.name,
          :error_message => "#{exception.class.name}: #{exception.message}",
          :backtrace     => exception.backtrace,
        }
      when Hash
        @exception
      end
      default_info.merge(data)
    end
    
    def default_info
      default_info = {
        :environment   => env,
        :ruby_version  => ruby_version,
        :ruby_platform => ruby_platform
      }
      default_info = add_ruby_info(default_info)
      default_info = add_rails_info(default_info) if rails_configuration
      default_info
    end
    
    # mergers
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

    # accessors    
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
