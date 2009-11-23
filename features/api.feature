Feature: Chatterbox API

  As a Chatterbox user
  I want to send messages using a simple API
  So that I can deliver many different types of notifications using different services

  Pending: Different API Ideas
  Given a file named "api_testing.rb" with:
    """
    Chatterbox.notify(:summary => "subject", :body => "body", 
      :via => { :service => :email, :to => "jdoe@example.com", :from => "foo.com" },
      :via => { :service => :twitter, :to => "rsanheim" },
      :via => { :destinations => ["my-inbox", "joes-house" }

    Chatterbox.notify(:summary => "subject", :body => "body") do |via|
      via.email :to => "jdoe@example.com", :from => "foo.com"
      via.twitter :to => "twitter"
    end
    """
  When I run "api_testing.rb"
  Then the exit code should be 0
    