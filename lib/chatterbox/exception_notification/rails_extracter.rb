module Chatterbox::ExceptionNotification
  class RailsExtracter
    def self.wrap(notification = {})
      new(notification).notice
    end

    def initialize(message = {})
      @message = message
    end

    def notice
      hsh = extract_rails_info(@message)
      hsh = extract_request_info(hsh)
      hsh = filter_rails_root(hsh)
      hsh
    end
    
    def filter_rails_root(hsh)
      return hsh unless hsh[:backtrace]
      cleaner = ActiveSupport::BacktraceCleaner.new
      cleaner.add_filter { |line| line.gsub(rails_root, "[RAILS_ROOT]") }
      backtrace = cleaner.clean(hsh[:backtrace])
      hsh[:backtrace] = backtrace
      hsh
    end

    def extract_rails_info(message)
      return message if rails_configuration.nil?
      message.merge({
        :rails_info => {
          :rails_env => rails_configuration.env.to_s,
          :rails_root => rails_root,
          :rails_version => rails_configuration.version
        }
      })
    end
    
    def extract_request_info(message)
      return message unless message.key?(:request)
      request = message.delete(:request)
      message.merge({
        :request => {
          :url => request.url,
          :remote_ip => request.remote_ip,
          :parameters => request.parameters
        }
      })
    end
    
    def rails_root
      rails_configuration.try(:root).to_s
    end

    def rails_configuration
      Object.const_get("Rails") if Object.const_defined?("Rails")
    end
    
  end
end