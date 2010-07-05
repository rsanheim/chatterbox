require 'spec_helper'
require 'chatterbox/exception_notification'

describe Chatterbox::ExceptionNotification::RailsExtracter do

  describe "wrap" do
    describe "when Rails is not defined or not found" do
      it "returns message unchanged" do
        Object.expects(:const_defined?).with("Rails").returns(false)
        original_hash = {:foo => "bar", :something => "else"}
        hsh = Chatterbox::ExceptionNotification::RailsExtracter.wrap(original_hash)
        hsh.should == original_hash
      end
    end
    
    describe "when Rails is defined" do
      it "merges in rails root, env, and version" do
        rails = stub_everything({
          :env => "production",
          :root => "/a/blah/current",
          :version => "2.3.2"
        })
        Chatterbox::ExceptionNotification::RailsExtracter.any_instance.stubs(:rails_configuration).returns(rails)
        details = Chatterbox::ExceptionNotification::RailsExtracter.wrap({})
        details[:rails_info][:rails_root].should == "/a/blah/current"
        details[:rails_info][:rails_env].should == "production"
        details[:rails_info][:rails_version].should == "2.3.2"
      end
    end

    describe "when handed a request as optional data" do
      it "should inclue url and remote ip" do
        request = stub_everything(:url => "http://example.com/fail-whale", :remote_ip => "192.5.5.0")
        details = Chatterbox::ExceptionNotification::RailsExtracter.wrap({:request => request})
        details[:request][:url].should == "http://example.com/fail-whale"
        details[:request][:remote_ip].should == "192.5.5.0"
      end
    end
    
    describe "cleaning RAILS_ROOT" do
      it "does nothing if there is no Rails configuration" do
        backtrace = %w[/some/path/here.rb]
        lambda {
          Chatterbox::ExceptionNotification::RailsExtracter.wrap({:backtrace => backtrace})
        }.should_not raise_error
      end

      it "does nothing if there is no rails_root on Rails" do
        Chatterbox::ExceptionNotification::RailsExtracter.any_instance.stubs(:rails_configuration).returns(stub_everything)
        backtrace = %w[/some/path/here.rb]
        details = Chatterbox::ExceptionNotification::RailsExtracter.wrap({:backtrace => backtrace})
        details[:backtrace].should == %w[/some/path/here.rb]
      end
      
      it "should replace the Rails root from the backtrace with RAILS_ROOT" do
        rails = stub_everything({ :root => "/var/apps/dogs.com" })
        Chatterbox::ExceptionNotification::RailsExtracter.any_instance.stubs(:rails_configuration).returns(rails)
        backtrace = %w[
/Users/rsanheim/.rvm/gems/ruby/1.9.1/gems/actionpack-2.3.4/lib/action_controller/test_process.rb:398:in `get'
/var/apps/dogs.com/app/controllers/users_controller.rb:5:in `index'
/var/apps/dogs.com/app/controllers/users_controller.rb:27:in `foo_baz'
/var/apps/dogs.com/lib/some_module.rb:10:in `something_else']
        details = Chatterbox::ExceptionNotification::RailsExtracter.wrap({:backtrace => backtrace})
        rails_lines = details[:backtrace].select { |line| line.include?("users_controller.rb") }
        rails_lines.should_not be_empty
        rails_lines.each do |line|
          line.should_not match(%r{^/var/apps/dogs.com/})
          line.should match(%r{^\[RAILS_ROOT\]})
        end
      end
    end
  end
  
  describe "rails_configuration" do
    it "returns top level Rails config if defined" do
      Object.expects(:const_defined?).with("Rails").returns(true)
      Object.expects(:const_get).with("Rails").returns("fake rails const")
      extracter = Chatterbox::ExceptionNotification::RailsExtracter.new({})
      extracter.rails_configuration.should == "fake rails const"
    end
  end

end