require 'example_helper'
require 'chatterbox/exception_notification'
require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. .. .. rails init]))

describe Chatterbox::RailsCatcher do
  
  def helper
    @helper ||= Class.new do
      def rescue_action_in_public(exception); end
      def self.hide_action(*name); end
      
      include Chatterbox::RailsCatcher
    end.new
  end
  
  def helper_with_request
    @helper ||= Class.new do
      def rescue_action_in_public(exception); end
      def self.hide_action(*names); end
      
      def request
        @request ||= stub_everything("fake request")
      end
      
      include Mocha::API
      include Chatterbox::RailsCatcher
    end.new
  end
  
  describe "configuration" do
    after do
      Chatterbox::RailsCatcher.configure { |c| c.ignore = Chatterbox::RailsCatcher.default_ignored_exceptions }
    end

    it "ignores common Rails exceptions by default" do
      Chatterbox::RailsCatcher.configuration.ignore.should == Chatterbox::RailsCatcher.default_ignored_exceptions
    end
    
    it "allows adding exceptions to the ignore list" do
      Chatterbox::RailsCatcher.configure do |config|
        config.ignore << "SomeOtherException"
      end
      Chatterbox::RailsCatcher.configuration.ignore.should include("SomeOtherException")
    end
  end
  
  describe "rescue_action_in_public_with_chatterbox" do
    describe "when request is not available" do
      it "sends exception and request hash to ExceptionNotification" do
        exception = stub_everything
        helper.stubs(:request).returns(request = stub_everything)
        Chatterbox::ExceptionNotification.expects(:handle).with(:exception => exception, :request => request)
        helper.rescue_action_in_public_with_chatterbox(exception)
      end
    end
    
    describe "when request is not available" do
      it "sends the exception hash on to ExceptionNotification" do
        Chatterbox::ExceptionNotification.expects(:handle).with(:exception => (exception = stub))
        helper.rescue_action_in_public_with_chatterbox(exception)
      end
    end
  end
end
