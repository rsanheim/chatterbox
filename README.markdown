Chatterbox
==========================================

Simple Notifications.  Publishing and subscribing to notifications is decoupled by default, so bring your own message queue, web service, database, or whatever to act as an intermediary.

Installing and Running
---------------------------------------

For plain old gem install: 

    gem install chatterbox "source" => "http://gemcutter.org"

To install within a Rails app, add the following to your environment.rb file:

    config.gem "chatterbox", :source => "http://gemcutter.org"

Then run:

    rake gems:install

To enable standard Rails exception catching for your controllers, add the following to `application_controller`

    class ApplicationController < ActionController::Base
      include Chatterbox::RailsCatcher
      # ...
    end
    
Then, wire up a producer


Example 1
---------------------------------------

Register the email service to handle messages that get sent to Chatterbox:

    Chatterbox::Publishers.register do |notice|
      Chatterbox::Services::Email.deliver(notice)
    end

Then, wherever you want to send email, do this:

    message = {
      :config => { :to => "joe@example.com", :from => "donotreply@example.com" },
      :message => { :summary => "your subject line here" }
    }
    Chatterbox.handle_notice(options)

Example 2
---------------------------------------

Wiring up notices to be sent to an exceptions queue, defined in RosettaQueue

    Chatterbox::Publishers.register do |notice|
      RosettaQueue::Producer.publish(:exceptions, notice)
    end


Bugs & Patches
--------------

Links
-------------

Contributors
------------
* Rob Sanheim

Copyrights
------------
* Copyright &copy; 2008-2009 [Relevance, Inc.](http://www.thinkrelevance.com/), under the MIT license
