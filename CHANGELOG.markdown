# Changelog

### 0.7.xxx
  - Simplify output for exception notification; using pretty print so hashes render well, even if they are nested
  - Deprecate `Chatterbox#handle_notice` -- use `#notify` instead; will be removed for 1.0
  
### 0.7.0
  - Add ability to configure `summary_prefix` for emails, for common case of "[my-app] " prefix line in the subject line for emails
  
### 0.6.2
  - Change to ExceptionNotification: render any other data in the hash that is not 
    enumerated in 'ordered sections'

### 0.6.1 
  - Handle case where there is no Rails Root defined
  
### 0.6.0
  - Extract exception handling to Chatterbox::ExceptionNotification, and have RailsCatcher use that
  - clean up and standardize names of things
  
### 0.5.4
  - Remove very dangerous delegation from RailsCatcher, as these delegates can override common
    ActionController::Base methods when the catcher is included.  Wishing Ruby had real namespaces
    right about now
  - Remove #log_prefix from RailsCatcher, simpler and not needed
    
### 0.5.3
  - exception filtering
  
### 0.5.2
  - add RAILS_ROOT filtering

### 0.5.1
  - to_s the env and root from Rails

### 0.5.0
  - Major rewrite and overhaul
  
### 0.4.2
  - handle_notice returns the message that was passed in

### 0.4.1 
  - top level alias `notify` for `handle_notice`
  - simplified logging - no longer tries to use Rails logger if it exists
  
### 0.4.0
  - removed notification wrapper around messages sent to Chatterbox to simplify things
  