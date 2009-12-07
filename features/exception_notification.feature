Feature: Exception Notification

  As a Chatterbox user
  I want to use Chatterbox for exception notifications
  So that I can deliver notifications over email 

  Scenario: Exceptions include the Chatterbox version string
  Given a file named "exceptions.rb" with:
    """
    require "chatterbox"
    require "chatterbox/exception_notification"
    require "chatterbox/services/email"
    ActionMailer::Base.delivery_method = :test

    Chatterbox::Publishers.register do |notice|
      Chatterbox::Services::Email.deliver(notice)
    end

    begin 
      1 / 0
    rescue => exception
      Chatterbox::ExceptionNotification.handle(:exception => exception, 
        :config => { :to => "to@example.com", :from => "from@example.com" })
    end
    
    puts ActionMailer::Base.deliveries.last.encoded
    """
  When I run "exceptions.rb"
  Then the exit code should be 0
  And the stdout should contain the Chatterbox version string message
  
