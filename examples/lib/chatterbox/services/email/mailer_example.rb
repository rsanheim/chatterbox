require 'example_helper'
require 'chatterbox/services/email'

describe Chatterbox::Services::Email::Mailer do
  before { ActionMailer::Base.delivery_method = :test }

  describe "wiring the email" do
    it "should set subject to the summary" do
      email = Chatterbox::Services::Email::Mailer.create_message(valid_options(:summary => "check this out"))
      email.subject.should == "check this out"
    end
    
    it "should use :summary_prefix if provided" do
      options = valid_options.dup
      options[:config] = valid_options[:config].merge(:summary_prefix => "[my-app] [notifications] ")
      email = Chatterbox::Services::Email::Mailer.create_message(options)
      email.subject.should == "[my-app] [notifications] here is a message"
    end
    
    it "should not require a body (for emails that are subject only)" do
      email = Chatterbox::Services::Email::Mailer.create_message(valid_options.merge(:body => nil))
      email.body.should be_blank # not nil for some reason -- ActionMailer provides an empty string somewhere
    end
    
    it "should set body to the body" do
      email = Chatterbox::Services::Email::Mailer.create_message(valid_options(:body => "here is my body"))
      email.body.should == "here is my body"
    end
    
    it "should set from" do
      email = Chatterbox::Services::Email::Mailer.create_message(valid_options.merge(:config => { :from => ["from@example.com"] }))
      email.from.should == ["from@example.com"]
    end
  end
  
  describe "content type" do
    it "can be set" do
      Chatterbox::Services::Email::Mailer.create_message(valid_options.merge(:config => { :content_type => "text/html"})).content_type.should == "text/html"
    end
    
    it "should default to text/plain" do
      Chatterbox::Services::Email::Mailer.create_message(valid_options).content_type.should == "text/plain"
    end
  end
  
  [:to, :cc, :bcc, :reply_to].each do |field| 
    describe "when configuring the #{field} field that takes one or many email addresses" do
      it "should allow setting a single address" do
        email = Chatterbox::Services::Email::Mailer.create_message(valid_options.merge(:config => { field => "joe@exmaple.com"}))
        email.send(field).should == ["joe@exmaple.com"]
      end
      
      it "should allow setting multiple addresses" do
        email = Chatterbox::Services::Email::Mailer.create_message(valid_options.merge(:config => { field => ["joe@example.com", "frank@example.com"]}))
        email.send(field).should == ["joe@example.com", "frank@example.com"]
      end
    end
  end

end