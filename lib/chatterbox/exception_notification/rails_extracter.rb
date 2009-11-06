module Chatterbox::ExceptionNotification
  class RailsExtracter
    def self.wrap(notification = {})
      new(notification).notice
    end

    def initialize(message = {})
      @message = message
    end

    def notice
      return @message if rails_configuration.nil?
      hsh = add_rails_info(@message)
      hsh
    end

    def rails_configuration
      Object.const_get("Rails") if Object.const_defined?("Rails")
    end

    def add_rails_info(message)
      message.merge({ :rails_info => {
        :rails_env => rails_configuration.env,
        :rails_root => rails_configuration.root,
        :rails_version => rails_configuration.version
        }
      })
    end
  end
end

