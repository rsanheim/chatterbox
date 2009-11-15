module Chatterbox::ExceptionNotification
  class Extracter
    attr_reader :message

    def self.wrap(notification = {})
      new(notification).notice
    end

    def initialize(message = {})
      @message = message
    end

    def notice
      hash = exception_to_notice(message)
      default_info.merge(hash)
    end

    def default_info
      default_info     = {
        :summary       => "N/A",
        :environment   => ENV.to_hash
      }
      default_info = add_ruby_info(default_info)
      default_info
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

    def add_ruby_info(data)
      data.merge({ 
        :ruby_info => {
          :ruby_version  => RUBY_VERSION,
          :ruby_platform => RUBY_PLATFORM
        }
      })
    end
  end
end