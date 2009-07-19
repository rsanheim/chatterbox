Chatterbox
==========================================

TODO summary

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



  


Rails Exception Integration
---------------------------------------

Example 1
---------------------------------------

Example 2
---------------------------------------

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
