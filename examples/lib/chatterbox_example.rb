require "example_helper"

describe Chatterbox do

  before do
    Chatterbox.logger = nil
    Chatterbox::Publishers.clear!
  end
  
  after do
    Chatterbox.logger = nil
  end
  
  describe "handle_notice" do
    it "should return notification" do
      Chatterbox.handle_notice("message").should == "message"
    end
    
    it "should publish the notice" do
      Chatterbox.expects(:publish_notice).with("message")
      Chatterbox.handle_notice("message")
    end
    
    it "should alias to notify" do
      Chatterbox.expects(:publish_notice).with("message")
      Chatterbox.notify("message")
    end
  end
  
  describe "logger" do
    it "should allow a logger to be set" do
      logger = Logger.new("/dev/null")
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
      notice = stub
      publisher = Chatterbox::Publishers.register { "i'm in your block" }
      publisher.expects(:call).with(notice)
      
      Chatterbox.publish_notice(notice)
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
  
end
