Feature: Sending email

  As a Chatterbox user
  I want to send emails using the same options as any other service
  So that I can deliver notifications over email

  @wip
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
      puts ActionMailer::Base.deliveries.last.encoded
      """
    When I run "simple_email_sending.rb"
    Then the exit code should be 0
    And the stdout should match "To: joe@example.com"
  
  Scenario: Sending with default configuration
    Given a file named "default_configuration_email_send.rb" with:
      """
      require "chatterbox"
      require "chatterbox/services/email"
      ActionMailer::Base.delivery_method = :test

      Chatterbox::Publishers.register do |notice|
        Chatterbox::Services::Email.deliver(notice)
      end
      Chatterbox::Services::Email.configure({
        :to => "to@example.com", :from => "from@example.com", :summary_prefix => "[CUKE] "
      })
      Chatterbox.notify :message => { :summary => "subject goes here!", :body => "body" }
      puts ActionMailer::Base.deliveries.last.encoded
      """
    When I run "default_configuration_email_send.rb"
    Then the exit code should be 0
    And the stdout should match "To: to@example.com"
    And the stdout should match "From: from@example.com"
    And the stdout should match "Subject: [CUKE] subject goes here!"

