Feature: Sending email

  As a Chatterbox user
  I want to send emails using the same options as any other service
  So that I can deliver notifications over email
  
  Scenario: Simple email sending
    Given a file named "simple_email_sending.rb" with:
      """
      require "chatterbox"
      require "chatterbox/services/email"
      ActionMailer::Base.delivery_method = :test
      
      Chatterbox::Publishers.register do |notice|
        Chatterbox::Services::Email.deliver(notice)
      end
      Chatterbox.notify :message => { :summary => "subject", :body => "body" },
        :config => { :to => "joe@example.com", :from => "sender@example.com" }
      """
    When I run "simple_email_sending.rb"
    Then the exit code should be 0
    And the stdout should match "recipient@example.com"
  
