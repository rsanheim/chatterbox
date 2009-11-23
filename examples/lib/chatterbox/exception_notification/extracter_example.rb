require 'example_helper'
require 'chatterbox/exception_notification'

describe Chatterbox::ExceptionNotification::Extracter do

  describe "notice" do
    it "merges default summary if none provided" do
      data = Chatterbox::ExceptionNotification::Extracter.new({}).notice
      data[:summary].should == "N/A"
    end
    
    it "merges environment hash" do
      hsh = {}
      data = Chatterbox::ExceptionNotification::Extracter.new(hsh).notice
      data[:environment].should == ENV.to_hash
    end

    it "merges ruby info" do
      hsh = {}
      data = Chatterbox::ExceptionNotification::Extracter.new(hsh).notice
      data[:ruby_info][:ruby_version].should == RUBY_VERSION
      data[:ruby_info][:ruby_platform].should == RUBY_PLATFORM
    end
    
    it "should extract exception info from an exception in a hash" do
      exception = RuntimeError.new("Your zing bats got mixed up with the snosh frazzles.")
      data = Chatterbox::ExceptionNotification::Extracter.new(:exception => exception, :other_info => "yo dawg").notice
      data[:summary].should == "RuntimeError: Your zing bats got mixed up with the snosh frazzles."
      data[:error_class].should == "RuntimeError"
      data[:error_message].should == "Your zing bats got mixed up with the snosh frazzles."
      data[:backtrace].should == exception.backtrace
      data[:other_info].should == "yo dawg"
    end

    it "should let extra data win over auto extracted exception data" do
      data = Chatterbox::ExceptionNotification::Extracter.new(:exception => Exception.new, :summary => "I know what I'm doing, and we got an error").notice
      data[:summary].should == "I know what I'm doing, and we got an error"
    end
  end
end