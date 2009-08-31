module Chatterbox
  class EmailConsumer
    
    attr_reader :notice
    
    def initialize(notice)
      @notice = notice
    end
    
    def process
      Chatterbox.logger.debug { "Mailing notification #{notice[:summary]}"}
      Mailer.deliver_exception_notification(notice)
    end
  
  end
  
  # Things taken out of the hash for exception emails:
  #
  # :details => a hash of details about the context of the error -- ie current state, request info, etc...any info
  #   related to the exception that is domain specific
  # :error_class => taken from the Exception
  # :error_message => taken from the Exception
  # :backtrace => taken from the Exception
  class Mailer < ActionMailer::Base
    @@sender_address = %("Exception Notifier" <exception.notifier@default.com>)
    cattr_accessor :sender_address

    @@exception_recipients = []
    cattr_accessor :exception_recipients

    @@email_prefix = "[ERROR] "
    cattr_accessor :email_prefix

    self.template_root = File.expand_path(File.join(File.dirname(__FILE__), *%w[.. .. views]))

    def self.reloadable?() false end

    def exception_notification(data={})
      data = data.dup.symbolize_keys
      
      content_type "text/plain"

      subject    "#{email_prefix} Error - #{data.delete(:summary)}"

      recipients exception_recipients
      from       sender_address

      body       data
    end

    private

      def sanitize_backtrace(trace)
        re = Regexp.new(/^#{Regexp.escape(rails_root)}/)
        trace.map { |line| Pathname.new(line.gsub(re, "[RAILS_ROOT]")).cleanpath.to_s }
      end

      def rails_root
        @rails_root ||= Pathname.new(RAILS_ROOT).cleanpath.to_s
      end

  end
  
end