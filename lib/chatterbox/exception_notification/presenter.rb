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
      { :message => { :summary => summary, :body => render_body },
        :config => @config }
    end
    
    def section_order
      [:error_message, :request, :backtrace, :environment, :ruby_info, :rails_info]
    end
    
    def render_body
      processed_keys = []
      body = ""
      extra_sections = options.keys - section_order
      extra_sections.each do |other_section|
      # extra_sections.each do |other_sections|
        output = render_section(other_section, processed_keys)
        body << output if output
      end
      section_order.each do |section|
        output = render_section(section, processed_keys)
        body << output if output
      end
      body
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
      if object.is_a?(Hash)
        render_hash(object)
      else
        render_non_hash(object)
      end
    end
    
    def render_non_hash(object)
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