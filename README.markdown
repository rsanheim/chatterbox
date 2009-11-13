Chatterbox
==========================================

Simple Notifications.  Publishing and subscribing to notifications is decoupled by default, so bring your own message queue, web service, database, or whatever to act as an intermediary.  Of course, you can wire Chatterbox to work directly if you like.

## Installing and Running

For plain old gem install: 

    gem install chatterbox "source" => "http://gemcutter.org"

To install within a Rails app, add the following to your environment.rb file:

    config.gem "chatterbox", :source => "http://gemcutter.org"

Then run:

    rake gems:install

## Exception Notification

One of the most handy use cases Chatterbox was developed for was Rails exception notification.  To setup Chatterbox for exception notification, install it as a gem with the instructions above, then configure it inside an initializer:

    Chatterbox::Services::Email.configure :to => "errors@example.com", :from => "donotreply@example.com"

    Chatterbox::Publishers.register do |notification|
      Chatterbox::Services::Email.deliver(notification)
    end

then wire the `RailsCatcher` in your `ApplicationController`:

    class ApplicationController < ActionController::Base
      include Chatterbox::RailsCatcher
    end

And you are done!  Exceptions thrown in controllers will automatically be processed and sent by Chatterbox, and then raised to be handled (or not handled) as normally.

## Example: Sending Emails
---------------------------------------

Register the email service to handle messages that get sent to Chatterbox:

    Chatterbox::Publishers.register do |notice|
      Chatterbox::Services::Email.deliver(notice)
    end

Then, wherever you want to send email, do this:

    message = {
      :config => { :to => "joe@example.com", :from => "donotreply@example.com" },
      :message => { :summary => "your subject line here", :body => "Email body here" }
    }
    Chatterbox.handle_notice(options)

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
