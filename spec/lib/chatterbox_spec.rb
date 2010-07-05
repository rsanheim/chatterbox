require "spec_helper"

describe Chatterbox do

  before { Chatterbox::Publishers.clear! }
  
  describe "notify" do
    it "should return notification" do
      Chatterbox.notify("message").should == "message"
    end
    
    it "should publish the notification" do
      Chatterbox.expects(:publish_notice).with({})
      Chatterbox.notify({})
    end
    
    describe "handle_notice alias" do
      it "is an publishes notification" do
        Chatterbox.expects(:publish_notice).with({})
        ActiveSupport::Deprecation.silence do
          Chatterbox.handle_notice({})
        end
      end
      
      it "is deprecated" do
        Chatterbox.expects(:deprecate).with("Chatterbox#handle_notice is deprecated and will be removed from Chatterbox 1.0. Call Chatterbox#notify instead.", anything)
        Chatterbox.handle_notice("message")
      end
    end
  end
  
  describe "deprecation" do
    it "uses ActiveSupport's Deprecation#warn" do
      stack = caller
      ActiveSupport::Deprecation.expects(:warn).with("deprecation warning here", stack)
      Chatterbox.deprecate("deprecation warning here", stack)
    end
  end
  
  describe "logger" do
    after { Chatterbox.logger = nil }
    
    it "should allow a logger to be set" do
      logger = Logger.new(nil)
      Chatterbox.logger = logger
      Chatterbox.logger.should == logger
    end
    
    it "uses logger with nil device by default" do
      Chatterbox.logger = nil
      Logger.expects(:new).with(nil).returns("logger")
      Chatterbox.logger.should == "logger"
    end
  end
  
  describe "publish" do
    it "should call each publisher with the notice" do
      publisher = Chatterbox::Publishers.register { "i'm in your block" }
      publisher.expects(:call).with({})
      
      Chatterbox.publish_notice({})
    end
  end

  describe "publishers" do
    it "should allow clearing all publishers" do
      Chatterbox::Publishers.register { "sending your messages" }
      Chatterbox::Publishers.publishers.size.should == 1
      Chatterbox::Publishers.clear!
      Chatterbox::Publishers.publishers.size.should == 0
    end
    
    it "should allow registering with a block" do
      pub1 = Chatterbox::Publishers.register { "sending your messages" }
      pub2 = Chatterbox::Publishers.register { "announcing your news" }
      Chatterbox::Publishers.publishers.should == [pub1, pub2]
    end
  end
  
  describe "register" do
    it "registers publisher" do
      pub = Chatterbox.register { "publisher" }
      Chatterbox::Publishers.publishers.should == [pub]
    end
  end
  
end
