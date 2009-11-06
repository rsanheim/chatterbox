require 'example_helper'
require 'chatterbox/exception_notification'

describe Chatterbox::ExceptionNotification::Extracter do

  def raised_exception
    raise RuntimeError, "Your zing bats got mixed up with the snosh frazzles."
  rescue => e
    e
  end
  
  describe "notice" do
    it "should extract exception info" do
      exception = raised_exception
      data = Chatterbox::ExceptionNotification::Extracter.new(exception).notice
      data[:summary].should == "RuntimeError: Your zing bats got mixed up with the snosh frazzles."
      data[:error_class].should == "RuntimeError"
      data[:error_message].should == "Your zing bats got mixed up with the snosh frazzles."
      data[:backtrace].should == exception.backtrace
    end

    it "should extract exception info from an exception in a hash" do
      exception = raised_exception
      data = Chatterbox::ExceptionNotification::Extracter.new(:exception => exception, :other_info => "yo dawg").notice
      data[:summary].should == "RuntimeError: Your zing bats got mixed up with the snosh frazzles."
      data[:error_class].should == "RuntimeError"
      data[:error_message].should == "Your zing bats got mixed up with the snosh frazzles."
      data[:backtrace].should == exception.backtrace
      data[:other_info].should == "yo dawg"
    end

    it "should let extra data win over auto extracted exception data" do
      exception = raised_exception
      data = Chatterbox::ExceptionNotification::Extracter.new(:exception => exception, :summary => "I know what I'm doing, and we got an error").notice
      data[:summary].should == "I know what I'm doing, and we got an error"
    end
  end
end