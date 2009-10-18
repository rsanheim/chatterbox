require 'example_helper'
require 'chatterbox/services/email'

describe Chatterbox::Services::Email do
  include Chatterbox
  ActionMailer::Base.delivery_method = :test
  
  describe "creation", :full_backtrace => true do
    it "is wired with valid options" do
      lambda {
        Chatterbox::Services::Email.deliver(valid_options)
      }.should_not raise_error
    end
    
    it "returns TMail::Mail instance" do
      result = Chatterbox::Services::Email.deliver(valid_options)
      result.should be_instance_of(TMail::Mail)
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
end