Feature: Configurable Services

  As a Chatterbox user
  I want to be able to configure only the services I need
  So that I can avoid unnecessary dependecies

  Scenario: No services loaded
  Given a file named "no_services_loaded.rb" with:
    """
    require "chatterbox"
    require "spec"
    require "spec/expectations"
    Chatterbox::Services.constants.should == []
    """
  When I run "no_services_loaded.rb"
  Then the exit code should be 0

  Scenario: Email service only
  Given a file named "email_service_only.rb" with:
    """
    require "chatterbox"
    require "chatterbox/services/email"
    require "spec"
    require "spec/expectations"
    Chatterbox::Services.constants.size.should == 1
    Chatterbox::Services.constants.first.to_sym.should == :Email
    """
  When I run "email_service_only.rb"
  Then the exit code should be 0

