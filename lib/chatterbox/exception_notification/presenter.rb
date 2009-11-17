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
      [:error_message, :request, :backtrace, :environment, :ruby_info, :rails_info]
    end
    
    def body
      body = ""
      section_order.each do |section|
        output = render_section(section)
        body << output if output
      end
      options.keys.each do |other_sections|
        output = render_section(other_sections)
        body << output if output
      end
      body
    end
    
    def render_section(key)
      return nil unless options.key?(key)
      output = key.to_s.titleize
      output << "\n"
      output << "----------\n"
      output << "#{inspect_value(options.delete(key))}\n\n"
      output
    end
    
    # Taken from exception_notification - thanks Jamis.
    def inspect_value(value)
      object_to_yaml(value).strip
    end

    def object_to_yaml(object)
      result = ""
      result << render_obj(object)
      result
    end
    
    def render_obj(object)
      if object.is_a?(Hash)
        render_hash(object)
      else
        render_non_hash(object)
      end
    end
    
    def render_non_hash(object)
      object.to_yaml.sub(/^---\s*\n?/, "")
    end
    
    # renders hashes with keys in sorted order
    def render_hash(hsh)
      str = ""
      indiff_hsh = hsh.with_indifferent_access
      indiff_hsh.keys.sort.each do |key|
        value = indiff_hsh[key]
        str << "#{key}: #{render_obj(value)}"
      end
      str
    end
  end
end