require 'example_helper'
require 'chatterbox/services/email'

describe Chatterbox::Services::Email do
  include Chatterbox
  ActionMailer::Base.delivery_method = :test
  
  before { Chatterbox::Services::Email.configure({}) }
  
  describe "creation" do
    it "is wired with valid options" do
      lambda {
        Chatterbox::Services::Email.deliver(valid_options)
      }.should_not raise_error
    end
    
    it "returns TMail::Mail instance" do
      result = Chatterbox::Services::Email.deliver(valid_options)
      result.should be_instance_of(TMail::Mail)
    end
    
    it "should preserve HashWithIndifferentAccess with explicit options" do
      options = { :message => { :summary => "foo" }, :config => {:to => "a", :from => "a"} }.with_indifferent_access
      service = Chatterbox::Services::Email.new(options)
      service.options.should be_instance_of(HashWithIndifferentAccess)
      service.options[:config].should be_instance_of(HashWithIndifferentAccess)
    end
    
    it "should preserve HashWithIndifferentAccess with default configuration" do
      options = { :message => { :summary => "foo" } }.with_indifferent_access
      Chatterbox::Services::Email.configure :to => "default-to@example.com", :from => "default-from@example.com"
      service = Chatterbox::Services::Email.new(options)
      service.options.should be_instance_of(HashWithIndifferentAccess)
      service.options[:config].should be_instance_of(HashWithIndifferentAccess)
    end
  end
  
  describe "validations" do
    it "should require :message" do
      lambda {
        Chatterbox::Services::Email.deliver(:config => { :from => "foo", :to => "foo"})
      }.should raise_error(ArgumentError, /Must configure with a :message/)
    end
    
    it "should require :message => :summary" do
      lambda {
        Chatterbox::Services::Email.deliver(:message => {}, :config => { :from => "foo", :to => "foo"})
      }.should raise_error(ArgumentError, /Must provide :summary in the :message/)
    end
    
    it "should require :to" do
      lambda {
        Chatterbox::Services::Email.deliver(:message => {:summary => ""}, :config => { :from => "anyone" })
      }.should raise_error(ArgumentError, /Must provide :to in the :config/)
    end
  
    it "should require from address" do
      lambda {
        Chatterbox::Services::Email.deliver(:message => {:summary => ""}, :config => { :to => "anyone"})
      }.should raise_error(ArgumentError, /Must provide :from in the :config/)
    end
  end
  
  describe "default_configuration=" do
    it "should default to empty hash" do
      Chatterbox::Services::Email.default_configuration.should == {}
    end
    
    it "should set a hash of default configuration into :config hash" do
      Chatterbox::Services::Email.configure :to => "to@example.com", :from => "from@example.com"
      Chatterbox::Services::Email.default_configuration.should == { :to => "to@example.com", :from => "from@example.com"}
    end
    
    it "should use default configuration" do
      Chatterbox::Services::Email.configure :to => "to@example.com", :from => "from@example.com"
      mail = Chatterbox::Services::Email.deliver(:message => {:summary => "summary"})
      mail.to.should == ["to@example.com"]
      mail.from.should == ["from@example.com"]
    end
    
    it "should allow message specific configuration" do
      Chatterbox::Services::Email.configure :to => "default-to@example.com", :from => "default-from@example.com"
      mail = Chatterbox::Services::Email.deliver(:message => {:summary => "summary"},
        :config => { :to => "joe@example.com", :from => "harry@example.com"} )
      mail.to.should == ["joe@example.com"]
      mail.from.should == ["harry@example.com"]
    end
  end
end