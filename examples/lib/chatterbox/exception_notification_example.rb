require 'example_helper'
require 'chatterbox/exception_notification'

describe Chatterbox::ExceptionNotification do
  
  describe "handling" do
    it "accepts exceptions" do
      Chatterbox::ExceptionNotification.handle(Exception.new)
    end
    
    it "accepts hashes" do
      Chatterbox::ExceptionNotification.handle(:exception => Exception.new)
    end
    
    describe "when on ignore list" do
      after do
        Chatterbox::ExceptionNotification.configure { |c| c.ignore = Chatterbox::ExceptionNotification.default_ignored_exceptions }
      end
      
      it "does not notify" do
        Chatterbox::ExceptionNotification.configure { |c| c.ignore << RuntimeError }
        Chatterbox.expects(:notify).never
        Chatterbox::ExceptionNotification.handle(:exception => RuntimeError.new)
      end
      
      it "returns nil for explicit exception" do
        Chatterbox::ExceptionNotification.configure { |c| c.ignore << RuntimeError }
        Chatterbox::ExceptionNotification.handle(RuntimeError.new).should be_nil
      end
      
      it "returns nil for :exception => exception" do
        Chatterbox::ExceptionNotification.configure { |c| c.ignore << RuntimeError }
        Chatterbox::ExceptionNotification.handle(:exception => RuntimeError.new).should be_nil
      end
      
      it "logs the ignore" do
        Chatterbox::ExceptionNotification.configure { |c| c.ignore << RuntimeError }
        Chatterbox.logger.expects(:debug).once
        Chatterbox::ExceptionNotification.handle(RuntimeError.new)
      end
      
      describe "with the ignore list manually turned off" do
        it "notifies" do
          Chatterbox::ExceptionNotification.configure { |c| c.ignore << RuntimeError }
          Chatterbox.expects(:notify)
          Chatterbox::ExceptionNotification.handle(:exception => RuntimeError.new, :use_ignore_list => false)
        end
      end
    end
    
    describe "when not on ignore list" do
      it "notifies" do
        Chatterbox.expects(:notify)
        Chatterbox::ExceptionNotification.handle(:exception => Exception.new)
      end
      
      it "logs nothing" do
        Chatterbox.logger.expects(:debug).never
        Chatterbox::ExceptionNotification.handle(:exception => Exception.new)
      end
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
  
  describe "configuration" do
    after do
      Chatterbox::ExceptionNotification.configure { |c| c.ignore = Chatterbox::ExceptionNotification.default_ignored_exceptions }
    end

    it "ignores common Rails exceptions by default" do
      Chatterbox::ExceptionNotification.configuration.ignore.should == Chatterbox::ExceptionNotification.default_ignored_exceptions
    end
    
    it "allows adding exceptions to the ignore list" do
      Chatterbox::ExceptionNotification.configure do |config|
        config.ignore << "SomeOtherException"
      end
      Chatterbox::ExceptionNotification.configuration.ignore.should include("SomeOtherException")
    end
  end
  
  
end