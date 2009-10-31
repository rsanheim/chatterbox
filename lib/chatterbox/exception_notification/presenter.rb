require 'pp'
require 'yaml'

module Chatterbox::ExceptionNotification
  class Presenter
    attr_reader :options
    
    def self.render(options)
      new(options).to_message
    end
    
    def initialize(options = {})
      @options = options
      @config = options[:config]
    end
    
    def summary
      options.delete(:summary)
    end
    
    def to_message
      { :message => { :summary => summary, :body => body },
        :config => @config }
    end
    
    def section_order
      [:error_message, :backtrace, :environment, :ruby_info, :rails_info]
    end
    
    def body
      body = ""
      section_order.each do |section|
        output = render_section(section)
        body << output if output
      end
      body
    end
    
    def render_section(key)
      return nil unless options.key?(key)
      output = key.to_s.titleize
      output << "\n"
      output << "----------\n"
      output << "#{inspect_value(options[key])}\n\n"
      output
    end
    
    # Taken from exception_notification - thanks Jamis.
    def inspect_value(value)
      len = 512
      result = object_to_yaml(value).rstrip
      result = result[0, len] + "... (#{result.length-len} bytes more)" if result.length > len+20
      result
    end

    def object_to_yaml(object)
      result = object.to_yaml.sub(/^---\s*\n?/, "")
    end
  end
end