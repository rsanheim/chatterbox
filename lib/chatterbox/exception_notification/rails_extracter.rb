module Chatterbox::ExceptionNotification
  class RailsExtracter
    def self.wrap(notification = {})
      new(notification).notice
    end

    def initialize(notification)
      @notification = notification
    end

    def notice
      hsh = extract_rails_info(@notification)
      hsh = extract_request_info(hsh)
      filter_rails_root(hsh)
    end
    
    def filter_rails_root(hash)
      return hash unless hash[:backtrace]
      return hash if rails_root.blank?
      cleaner = ActiveSupport::BacktraceCleaner.new
      cleaner.add_filter { |line| line.gsub(rails_root, "[RAILS_ROOT]") }
      backtrace = cleaner.clean(hash[:backtrace])
      hash[:backtrace] = backtrace
      hash
    end

    def extract_rails_info(hash)
      return hash if rails_configuration.nil?
      hash.merge({
        :rails_info => {
          :rails_env => rails_configuration.env.to_s,
          :rails_root => rails_root,
          :rails_version => rails_configuration.version
        }
      })
    end
    
    def extract_request_info(hash)
      return hash unless hash.key?(:request)
      request = hash.delete(:request)
      hash.merge({
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