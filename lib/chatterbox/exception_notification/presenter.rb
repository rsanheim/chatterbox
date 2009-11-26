require 'yaml'
require 'pp'

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
      { :summary => summary, 
        :body => render_body,
        :config => @config }
    end
    
    def error_details
      [:error_message, :request, :backtrace, :environment, :ruby_info, :rails_info]
    end
    
    def render_body
      processed_keys = []
      extra_sections = options.keys - error_details
      body = render_sections(extra_sections, processed_keys)
      body << render_sections(error_details, processed_keys)
      body
    end
    
    def render_sections(keys, already_processed)
      keys.inject(String.new) do |str, key|
        output = render_section(key, already_processed)
        str << output if output
        str
      end
    end
    
    def render_section(key, processed_keys = [])
      processed_keys << key
      return nil unless options.key?(key)
      output = "#{key.to_s.titleize}\n"
      output << "----------\n"
      output << render_obj(options[key])
      output << "\n"
      output
    end
    
    def render_obj(object)
      case object
      when Hash then render_hash(object)
      when Array then render_array(object)
      else render_object(object)
      end
    end

    def render_array(object)
      render_object(object.join("\n"))
    end

    def render_object(object)
      "#{object}\n"
    end
    
    # renders hashes with keys in alpha-sorted order
    def render_hash(hsh)
      str = ""
      indiff_hsh = hsh.with_indifferent_access
      indiff_hsh.keys.sort.each do |key|
        str << "#{key}: "
        value = indiff_hsh[key]
        PP::pp(value, str)
      end
      str
    end
  end
end