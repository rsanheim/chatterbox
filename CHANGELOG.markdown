HEAD

0.5.4
  - Remove very dangerous delegation from RailsCatcher, as these delegates can override common
    ActionController::Base methods when the catcher is included.  Wishing Ruby had real namespaces
    right about now
  - Remove #log_prefix from RailsCatcher, simpler and not needed
    
0.5.3
  - exception filtering
  
0.5.2
  - add RAILS_ROOT filtering

0.5.1
  - to_s the env and root from Rails

0.5.0 
  - Major rewrite and overhaul
  
0.4.2

  - handle_notice returns the message that was passed in

0.4.1

  - top level alias `notify` for `handle_notice`
  - simplified logging - no longer tries to use Rails logger if it exists
  
0.4.0
  
  - removed notification wrapper around messages sent to Chatterbox to simplify things
  