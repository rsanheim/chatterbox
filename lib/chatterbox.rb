require File.join(File.dirname(__FILE__), *%w[chatterbox notification])
require File.join(File.dirname(__FILE__), *%w[consumers])

module Chatterbox
  IGNORE_DEFAULT = ['ActiveRecord::RecordNotFound',
                    'ActionController::RoutingError',
                    'ActionController::InvalidAuthenticityToken',
                    'CGI::Session::CookieStore::TamperedWithCookie',
                    'ActionController::UnknownAction']

  # Some of these don't exist for Rails 1.2.*, so we have to consider that.
  IGNORE_DEFAULT.map!{|e| eval(e) rescue nil }.compact!
  IGNORE_DEFAULT.freeze

  IGNORE_USER_AGENT_DEFAULT = []

  def handle_notice(message)
    notice = Notification.new(message).notice
    publish_notice(notice)
  end

  def publish_notice(notice)
    Publishers.publishers.each { |p| p.call(notice) }
  end
  
  extend self
  
  module Publishers

    class << self

      def publishers
        @publishers ||= []
      end
      
      def register(&blk)
        publishers << blk
        blk
      end
      
      def clear!
        @publishers = []
      end

    end
    
  end
  
end

