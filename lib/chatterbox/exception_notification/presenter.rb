require 'pp'
require 'yaml'

module Chatterbox::ExceptionNotification
  class Presenter
    attr_reader :options
    
    def self.render(options)
      new(options).to_message
    end
    
    def initialize(options)
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
      output << "#{prettyify_output(options[key])}\n\n"
      output
    end
    
    def prettyify_output(object)
      object.to_yaml.sub(/^---\s*/m, "").gsub(/\n/, "\n  ").strip
    end
  end
end