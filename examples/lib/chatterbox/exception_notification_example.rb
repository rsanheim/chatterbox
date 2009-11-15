require 'example_helper'
require 'chatterbox/exception_notification'

describe Chatterbox::ExceptionNotification do
  EN = Chatterbox::ExceptionNotification
  
  describe "handle" do
    it "accepts exceptions" do
      Chatterbox::ExceptionNotification.handle(Exception.new)
    end
    
    it "accepts hashes" do
      Chatterbox::ExceptionNotification.handle(:exception => Exception.new)
    end
    
    it "normalizes and extracts details" do
      exception = Exception.new
      Chatterbox::ExceptionNotification.expects(:normalize_to_hash).with(exception).returns(hsh = {})
      Chatterbox::ExceptionNotification.expects(:extract_details).with({}).returns({})
      Chatterbox::ExceptionNotification.handle(exception).should == {}
    end
  end
  
  describe "normalize_to_hash" do
    it "returns :exception =>  for exception" do
      exception = RuntimeError.new
      Chatterbox::ExceptionNotification.normalize_to_hash(exception).should == { :exception => exception }
    end
    
    it "returns hashes as is" do
      Chatterbox::ExceptionNotification.normalize_to_hash({}).should == {}
    end
    
    it "returns string like objects as :summary => obj.to_s" do
      Chatterbox::ExceptionNotification.normalize_to_hash("failure").should == { :summary => "failure" }
    end
  end
end