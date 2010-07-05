require 'spec_helper'
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
