require File.join(File.dirname(__FILE__), *%w[example_helper])

describe Chatterbox do

  before do
    Chatterbox.logger = Logger.new(nil)
    Chatterbox::Publishers.clear!
  end
  
  after do
    Chatterbox.logger = nil
  end
  
  describe "handle_notice" do
    include Chatterbox
    
    it "should publish the notice" do
      Chatterbox.expects(:publish_notice).with("message")
      Chatterbox.handle_notice("message")
    end
    
  end
  
  describe "logger" do
    
    it "uses STDOUT logger if Rails not available" do
      Chatterbox.logger = nil
      
      Logger.expects(:new).with(STDOUT).returns("logger")
      Chatterbox.stubs(:rails_default_logger).returns(nil)
      Chatterbox.logger.should == "logger"
    end
  end
  
  describe "publish" do
    
    include Chatterbox
    
    it "should call each publisher with the notice" do
      notice = stub
      publisher = Chatterbox::Publishers.register { "i'm in your block" }
      publisher.expects(:call).with(notice)
      
      publish_notice(notice)
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
