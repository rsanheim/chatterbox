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
    
    
    def body
      body = ""
      body << render_section(:environment)
      body
    end
    
    def render_section(key)
      <<-EOL
#{key}
----------
EOL
    end
    
    
  end
end