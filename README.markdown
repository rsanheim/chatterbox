Chatterbox
==========================================

Simple Notifications.  Publishing and subscribing to notifications is decoupled by default, so bring your own message queue, web service, database, or whatever to act as an intermediary.

Installing and Running
---------------------------------------

To install within a Rails app:

Add the following to your environment.rb file:

    config.gem "relevance-chatterbox"

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

Wiring messages to be sent by Email service

    Chatterbox::Publishers.register do |notice|
      Chatterbox::Email.deliver(notice)
    end

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
