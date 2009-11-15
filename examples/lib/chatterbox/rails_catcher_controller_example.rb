require 'example_helper'
require 'chatterbox/exception_notification'
require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. .. .. rails init]))

ActionController::Routing::Routes.draw { |map| map.connect ':controller/:action/:id' }

class WidgetException < RuntimeError; end
class WidgetsController < ActionController::Base
  include Chatterbox::RailsCatcher

  def rescue_action(exception)
    rescue_action_in_public(exception)
  end
  
  def rescue_action_in_public_without_chatterbox(exception)
    raise exception
  end
  
  def index
    raise_exception
    render :text => "hi"
  end
  
  def raise_exception
    raise WidgetException, "Bad dog!"
  end
end

describe WidgetsController do
  
  describe "controller haxing" do
    it "chains the chatterbox method to rescue_action_in_public" do
      exception = RuntimeError.new
      @controller.expects(:rescue_action_in_public_without_chatterbox).with(exception)
      @controller.stubs(:extract_exception_details)
      @controller.rescue_action_in_public(exception)
    end
  
    it "should have the catcher included in ApplicationController" do
      WidgetsController.ancestors.should include(Chatterbox::RailsCatcher)
    end
    
    it "should hide aliased methods so they are not exposed as actions" do
      WidgetsController.hidden_actions.should include("rescue_action_in_public_with_chatterbox")
      WidgetsController.hidden_actions.should include("rescue_action_in_public_without_chatterbox")
    end
  end
  
  describe "exception handling" do
    it "should raise on index" do
      lambda {
        get :index
      }.should raise_error(WidgetException, "Bad dog!")
    end
    
    it "should send exception notice as hash" do
      Chatterbox::ExceptionNotification.expects(:handle).with(instance_of(Hash))
      get :index rescue nil
    end
  end
  
  describe "ignoring exceptions" do
    describe "when configured to ignore RuntimeError (as class)" do
      before do
        Chatterbox::RailsCatcher.configure { |c| c.ignore << RuntimeError }
      end
      
      after do
        Chatterbox::RailsCatcher.configure { |c| c.ignore = Chatterbox::RailsCatcher.default_ignored_exceptions }
      end
      
      it "handles exceptions normally" do
        lambda {
          @controller.rescue_action_in_public(RuntimeError.new)
        }.should raise_error(RuntimeError)
      end
      
      it "ignores anything configured on the ignore list" do
        Chatterbox.expects(:handle_notice).never
        begin
          @controller.rescue_action_in_public(RuntimeError.new)
        rescue RuntimeError; end
      end
    end
    
    describe "when configured to ignore RuntimeError (as String)" do
      before do
        Chatterbox::RailsCatcher.configure { |c| c.ignore << "RuntimeError" }
      end
      
      after do
        Chatterbox::RailsCatcher.configure { |c| c.ignore = Chatterbox::RailsCatcher.default_ignored_exceptions }
      end
      
      it "handles exceptions normally" do
        lambda {
          @controller.rescue_action_in_public(RuntimeError.new)
        }.should raise_error(RuntimeError)
      end
      
      it "ignores anything configured on the ignore list" do
        Chatterbox.expects(:handle_notice).never
        begin
          @controller.rescue_action_in_public(RuntimeError.new)
        rescue RuntimeError; end
      end
    end
  end
end