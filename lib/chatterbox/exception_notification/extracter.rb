module Chatterbox::ExceptionNotification
  class Extracter
    def self.wrap(notification = {})
      new(notification).notice
    end

    def initialize(notification)
      @notification = notification
    end

    def notice
      hash = extract_exception_info(@notification)
      hash = extract_ruby_info(hash)
      extract_default_info(hash)
    end

    def extract_default_info(hash)
      hsh = { :summary       => "N/A",
              :environment   => ENV.to_hash,
              :chatterbox_info => "Chatterbox Version #{Chatterbox::Version::STRING}"
      }.merge(hash)
    end

    def extract_exception_info(hash)
      return hash unless hash.key?(:exception)
      exception = hash[:exception]
      {
        :summary => "#{exception.class.name}: #{exception.message}",
        :error_class   => exception.class.name,
        :error_message => exception.message,
        :backtrace     => exception.backtrace,
      }.merge(hash)
    end

    def extract_ruby_info(hash)
      hash.merge({ 
        :ruby_info => {
          :ruby_version  => RUBY_VERSION,
          :ruby_platform => RUBY_PLATFORM
        }
      })
    end
  end
end