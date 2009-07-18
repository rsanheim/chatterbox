require File.join(File.dirname(__FILE__), *%w[queued_exceptions notification])
require File.join(File.dirname(__FILE__), *%w[consumers])

module QueuedExceptions
  IGNORE_DEFAULT = ['ActiveRecord::RecordNotFound',
                    'ActionController::RoutingError',
                    'ActionController::InvalidAuthenticityToken',
                    'CGI::Session::CookieStore::TamperedWithCookie',
                    'ActionController::UnknownAction']

  # Some of these don't exist for Rails 1.2.*, so we have to consider that.
  IGNORE_DEFAULT.map!{|e| eval(e) rescue nil }.compact!
  IGNORE_DEFAULT.freeze

  IGNORE_USER_AGENT_DEFAULT = []

  # TODO: logging
  def self.handle(hash_or_exception)
      notice = normalize_notice(hash_or_exception)
      # notice = clean_notice(notice)
      publish(notice)
  end

  def self.default_notice_options #:nodoc:
    {
      :error_message => 'Notification',
      :backtrace     => caller,
      :request       => {},
      :session       => {},
      :environment   => ENV.to_hash
    }
  end
  
  def self.normalize_notice(notice) #:nodoc:
    case notice
    when Hash
      default_notice_options.merge(notice)
    when Exception
      default_notice_options.merge(exception_to_data(notice))
    end
  end
  
  def self.exception_to_data exception #:nodoc:
    data = {
      :error_class   => exception.class.name,
      :error_message => "#{exception.class.name}: #{exception.message}",
      :backtrace     => exception.backtrace,
      :environment   => ENV.to_hash
    }

    if self.respond_to? :request
      data[:request] = {
        :params      => request.parameters.to_hash,
        :rails_root  => File.expand_path(RAILS_ROOT),
        :url         => "#{request.protocol}#{request.host}#{request.request_uri}"
      }
      data[:environment].merge!(request.env.to_hash)
    end

    if self.respond_to? :session
      data[:session] = {
        :key         => session.instance_variable_get("@session_id"),
        :data        => session.respond_to?(:to_hash) ?
                          session.to_hash :
                          session.instance_variable_get("@data")
      }
    end

    data
  end
  
  # Notifiers
  def self.publish(notice)
    @handlers.each do |blk|
      blk.call(notice)
    end
  end
  
  def self.register_handler(&blk)
    (@handlers = []) << blk
  end
  
end

