require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. .. example_helper]))

describe Chatterbox::Notification do

  before do
    Chatterbox.logger = Logger.new(nil)
  end

  describe "creating the notice" do

    it "should safely handle nil" do
      lambda {
        Chatterbox::Notification.new(nil).notice
      }.should_not raise_error
    end
    
    it "should use to_hash if message is not an exception and it responds_to possible" do
      some_object = mock(:to_hash => {:foo => "bar"})
      Chatterbox::Notification.new(some_object).notice.should include({:foo => "bar"})
    end
    
    it "should call to_s on anything that responds to it, as a last resort" do
      some_object = mock(:to_s => "my to_s")
      Chatterbox::Notification.new(some_object).notice.should include({:summary => "my to_s"})
    end
    
    it "merges hash passed in with default info" do
      hash = {:message => "hey!"}
      default_info = mock()
      default_info.expects(:merge).with(hash)
      notification = Chatterbox::Notification.new(hash)
      notification.expects(:default_info).returns(default_info)
      notification.notice
    end
    
    it "turns string notice into a hash keyed by notice" do
      notification = Chatterbox::Notification.new("You have been placed on alert")
      notification.notice.should include({:summary => "You have been placed on alert"})
    end
    
    it "always includes a summary" do
      Chatterbox::Notification.new().notice.should include(:summary)
      Chatterbox::Notification.new({}).notice.should include(:summary)
      Chatterbox::Notification.new(RuntimeError.new).notice.should include(:summary)
    end
    
    it "should set summary to N/A if nothing provided" do
      Chatterbox::Notification.new({}).notice.should include(:summary => "N/A")
      Chatterbox::Notification.new({:foo => 'baz'}).notice.should include(:summary => "N/A")
    end
  end
  
  describe "exceptions" do
    
    def raised_exception
      raise RuntimeError, "Your zing bats got mixed up with the snosh frazzles."
    rescue => e
      e
    end

    it "should extract exception info" do
      exception = raised_exception
      data = Chatterbox::Notification.new(exception).notice
      data[:summary].should == "RuntimeError: Your zing bats got mixed up with the snosh frazzles."
      data[:error_class].should == "RuntimeError"
      data[:error_message].should == "Your zing bats got mixed up with the snosh frazzles."
      data[:backtrace].should == exception.backtrace
    end
    
    it "should extract exception info from an exception in a hash" do
      exception = raised_exception
      data = Chatterbox::Notification.new(:exception => exception, :other_info => "yo dawg").notice
      data[:summary].should == "RuntimeError: Your zing bats got mixed up with the snosh frazzles."
      data[:error_class].should == "RuntimeError"
      data[:error_message].should == "Your zing bats got mixed up with the snosh frazzles."
      data[:backtrace].should == exception.backtrace
      data[:other_info].should == "yo dawg"
    end
    
    it "should let extra data win over auto extracted exception data" do
      exception = raised_exception
      data = Chatterbox::Notification.new(:exception => exception, :summary => "I know what I'm doing, and we got an error").notice
      data[:summary].should == "I know what I'm doing, and we got an error"
    end
    
    it "merges rails info and ruby info into the exception info" do
      notification = Chatterbox::Notification.new(raised_exception)
      rails = stub_everything(:version => "2.0", :root => "/rails/root", :env => "production")
      notification.stubs(:rails_configuration).returns(rails)
      notification.notice.should include(:rails_version => "2.0")
      notification.notice.should include(:rails_root => "/rails/root")
      notification.notice.should include(:rails_env => "production")
    end
    
  end
  
  describe "hashes" do 

    it "merges rails info and ruby info into the notification" do
      notification = Chatterbox::Notification.new({})
      rails = stub_everything(:version => "2.0", :root => "/rails/root", :env => "production")
      notification.stubs(:rails_configuration).returns(rails)
      notification.notice.should include(:rails_version => "2.0")
      notification.notice.should include(:rails_root => "/rails/root")
      notification.notice.should include(:rails_env => "production")
    end
    
  end
  
  describe "default info to be included with every notification" do
    
    it "should return full ENV" do
      environment = { "USER" => "jdoe", "PATH" => "/usr/bin", "HOME" => "/usr/home/jdoe" }
      notification = Chatterbox::Notification.new
      notification.stubs(:env).returns(environment)
      notification.default_info.should include(:environment => environment)
    end
    
    it "should return Ruby version and platform" do
      notification = Chatterbox::Notification.new
      notification.stubs(:ruby_version).returns("1.8.6")
      notification.stubs(:ruby_platform).returns("Mac OS X blah")
      data = notification.default_info
      data.should include(:ruby_version => "1.8.6")
      data.should include(:ruby_platform => "Mac OS X blah")
    end
    
    describe "when Rails is defined" do
      
      it "should return Rails info" do
        notification = Chatterbox::Notification.new
        rails = stub
        rails.stubs(:root).returns("/some/path")
        rails.stubs(:env).returns("production")
        rails.stubs(:version).returns("2.1.2")
        notification.stubs(:rails_configuration).returns(rails)
        
        notification.default_info.should include(:rails_root => "/some/path")
        notification.default_info.should include(:rails_env => "production")
        notification.default_info.should include(:rails_version => "2.1.2")
      end
      
    end
    
  end
  
end