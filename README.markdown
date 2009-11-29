Chatterbox
==========================================

Chatterbox is a library to send notifications and messages over whatever service you like, whether it be email, Twitter, Campfire, IRC, or some combination therein.  The goal of Chatterbox is to be able to send a message from your application via whatever service the user prefers simple by tweaking the configuration hash that gets sent to Chatterbox.

Publishing and subscribing to notifications can be decoupled easily, so bring your own message queue, web service, database, or whatever to act as an intermediary.  Or keep it simple and wire Chatterbox directly - its your choice.

## Installing and Running

For plain old gem install: 

    gem install chatterbox

To install within a Rails app, add the following to your environment.rb file:

    config.gem "chatterbox"

Then run:

    rake gems:install

## Services

Services are used to send notifications in Chatterbox.  Chatterbox comes with an email service for use out of the box, which uses ActionMailer and works pretty much how you would expect.

## Email Service Configuration

Register the email service to handle messages that get sent to Chatterbox:

    Chatterbox::Publishers.register do |notice|
      Chatterbox::Services::Email.deliver(notice)
    end

Then, wherever you want to send email, do this:

    options = {
      :summary => "your subject line here", :body => "Email body here",
      :config => { :to => "joe@example.com", :from => "donotreply@example.com" },
    }
    Chatterbox.notify(options)

You can configure defaults for the email service:

    Chatterbox::Services::Email.configure({
      :to => "joe@example.com",
      :from => "jane@example.com", 
      :summary_prefix => "[my-prefix] "
    })

Then when you deliver messages, the provided options will be merged with the defaults:

    Chatterbox.notify(:message => { :summary => "my subject" })

Sends:

    To: joe@example.com
    From: jane@example.com
    Subject: [my-prefix] my subject

While the following overrides the default to and from addresses...

    options = {
      :summary => "my subject",
      :config => { :to => "distro@example.com", :from => "reply@example.com" },
    }
    Chatterbox.notify(options)

Sends:

    To: distro@example.com
    From: reply@example.com
    Subject: [my-prefix] my subject

## Exception Notification

One of the most handy use cases Chatterbox was developed for is exception notification.  Chatterbox can be configured for Rails exception catching from controllers, and can be used in a plain Ruby app as well.  

To setup Chatterbox for Rails exception notification, install it as a gem with the instructions above, then configure it inside an initializer:

    Chatterbox::Services::Email.configure :to => "errors@example.com", :from => "donotreply@example.com"

    Chatterbox::Publishers.register do |notification|
      Chatterbox::Services::Email.deliver(notification)
    end

then wire the `RailsCatcher` in your `ApplicationController`:

    class ApplicationController < ActionController::Base
      include Chatterbox::RailsCatcher
    end

And you are done!  Exceptions thrown in controllers will automatically be processed and sent by Chatterbox, and then raised to be handled (or not handled) as normally.


Bugs & Patches
--------------
Please submit to [Github Issues](http://github.com/rsanheim/chatterbox/TODO).

All patches must have spec coverage and a passing build, or they will be pushed back.

You can easily verify your build by pushing the project to [RunCodeRun](http://runcoderun.com).  View the [master build](http://runcoderun.com/rsanheim/chatterbox) to confirm that HEAD is stable and passing.

Links
-------------

Contributors
------------
* Rob Sanheim (creator)
* Chad Humphries (API ideas)

Copyrights
------------
Copyright &copy; 2008-2009 Rob Sanheim under the MIT license