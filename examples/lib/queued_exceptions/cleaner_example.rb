require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. .. example_helper]))
require 'ostruct'

describe QueuedExceptions::Cleaner do

  describe "building the message" do
    
    it "merges hash passed in with default info" do
      hash = {:message => "hey!"}
      default_info = mock()
      default_info.expects(:merge).with(hash)
      cleaner = QueuedExceptions::Cleaner.new(hash)
      cleaner.expects(:default_info).returns(default_info)
      cleaner.clean
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
      data = QueuedExceptions::Cleaner.new(exception).clean
      data[:error_class].should == "RuntimeError"
      data[:error_message].should == "RuntimeError: Your zing bats got mixed up with the snosh frazzles."
      data[:backtrace].should == exception.backtrace
    end
    
    it "merges rails info and ruby info into the exception info" do
      cleaner = QueuedExceptions::Cleaner.new(raised_exception)
      rails = stub_everything(:version => "2.0", :root => "/rails/root", :env => "production")
      cleaner.stubs(:rails_configuration).returns(rails)
      cleaner.clean.should include(:rails_version => "2.0")
      cleaner.clean.should include(:rails_root => "/rails/root")
      cleaner.clean.should include(:rails_env => "production")
    end
    
  end
  
  describe "hashes" do 

    it "merges rails info and ruby info into the notification" do
      cleaner = QueuedExceptions::Cleaner.new({})
      rails = stub_everything(:version => "2.0", :root => "/rails/root", :env => "production")
      cleaner.stubs(:rails_configuration).returns(rails)
      cleaner.clean.should include(:rails_version => "2.0")
      cleaner.clean.should include(:rails_root => "/rails/root")
      cleaner.clean.should include(:rails_env => "production")
    end
    
  end
  
  describe "default info to be included with every notification" do
    
    it "should return full ENV" do
      environment = { "USER" => "jdoe", "PATH" => "/usr/bin", "HOME" => "/usr/home/jdoe" }
      cleaner = QueuedExceptions::Cleaner.new
      cleaner.stubs(:env).returns(environment)
      cleaner.default_info.should include(:environment => environment)
    end
    
    it "should return Ruby version and platform" do
      cleaner = QueuedExceptions::Cleaner.new
      cleaner.stubs(:ruby_version).returns("1.8.6")
      cleaner.stubs(:ruby_platform).returns("Mac OS X blah")
      data = cleaner.default_info
      data.should include(:ruby_version => "1.8.6")
      data.should include(:ruby_platform => "Mac OS X blah")
    end
    
    describe "when Rails is defined" do
      
      it "should return Rails info" do
        cleaner = QueuedExceptions::Cleaner.new
        rails = stub
        rails.stubs(:root).returns("/some/path")
        rails.stubs(:env).returns("production")
        rails.stubs(:version).returns("2.1.2")
        cleaner.stubs(:rails_configuration).returns(rails)
        
        cleaner.default_info.should include(:rails_root => "/some/path")
        cleaner.default_info.should include(:rails_env => "production")
        cleaner.default_info.should include(:rails_version => "2.1.2")
      end
      
    end
    
  end

end