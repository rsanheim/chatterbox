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
      hsh
    end

    def rails_configuration
      Object.const_get("Rails") if Object.const_defined?("Rails")
    end

    def extract_rails_info(message)
      return message if rails_configuration.nil?
      message.merge({
        :rails_info => {
          :rails_env => rails_configuration.env,
          :rails_root => rails_configuration.root,
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
  end
end


# 
# * URL       : <%= @request.protocol %><%= @host %><%= @request.request_uri %>
# * IP address: <%= @request.env["HTTP_X_FORWARDED_FOR"] || @request.env["REMOTE_ADDR"] %>
# * Parameters: <%= filter_sensitive_post_data_parameters(@request.parameters).inspect %>
# * Rails root: <%= @rails_root %>
