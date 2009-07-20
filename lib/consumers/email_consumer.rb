module Chatterbox
  class EmailConsumer
    
    attr_reader :notice
    
    def initialize(notice)
      @notice = notice
    end
    
    def process
      Chatterbox.logger.debug { "Mailing notification #{notice['summary']}"}
      Mailer.deliver_exception_notification(notice)
    end
  
  end
  
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
      content_type "text/plain"

      d { data }
      subject    "#{email_prefix} Error - #{data['summary']}"

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