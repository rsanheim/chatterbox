require 'example_helper'
require 'chatterbox/exception_notification'

describe Chatterbox::ExceptionNotification::Filter do

  describe "rails_configuration" do
    it "returns top level Rails config if defined" do
      old_rails = defined?(Rails) && Rails
      rails = old_rails || Object.const_set("Rails", "fake rails")
      filter = Chatterbox::ExceptionNotification::Filter.new
      filter.rails_configuration.should == rails
      Object.const_set("Rails", nil) unless old_rails
    end
  end
  
  def raised_exception
    raise RuntimeError, "Your zing bats got mixed up with the snosh frazzles."
  rescue => e
    e
  end
  
  describe "notice" do
    it "should extract exception info" do
      exception = raised_exception
      data = Chatterbox::ExceptionNotification::Filter.new(exception).notice
      data[:summary].should == "RuntimeError: Your zing bats got mixed up with the snosh frazzles."
      data[:error_class].should == "RuntimeError"
      data[:error_message].should == "Your zing bats got mixed up with the snosh frazzles."
      data[:backtrace].should == exception.backtrace
    end

    it "should extract exception info from an exception in a hash" do
      exception = raised_exception
      data = Chatterbox::ExceptionNotification::Filter.new(:exception => exception, :other_info => "yo dawg").notice
      data[:summary].should == "RuntimeError: Your zing bats got mixed up with the snosh frazzles."
      data[:error_class].should == "RuntimeError"
      data[:error_message].should == "Your zing bats got mixed up with the snosh frazzles."
      data[:backtrace].should == exception.backtrace
      data[:other_info].should == "yo dawg"
    end

    it "should let extra data win over auto extracted exception data" do
      exception = raised_exception
      data = Chatterbox::ExceptionNotification::Filter.new(:exception => exception, :summary => "I know what I'm doing, and we got an error").notice
      data[:summary].should == "I know what I'm doing, and we got an error"
    end

    it "merges rails info and ruby info into the exception info" do
      notification = Chatterbox::ExceptionNotification::Filter.new(raised_exception)
      rails = stub_everything(:version => "2.0", :root => "/rails/root", :env => "production")
      notification.stubs(:rails_configuration).returns(rails)
      rails_info = notification.notice[:rails_info]
      rails_info.should include(:rails_version => "2.0")
      rails_info.should include(:rails_root => "/rails/root")
      rails_info.should include(:rails_env => "production")
    end

  end
end