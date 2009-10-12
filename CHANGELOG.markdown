HEAD

  - top level alias `notify` for `handle_notice`
  - removed EmailConsumer - use http://github.com/rsanheim/chatterbox-email
  - simplified logging - no longer tries to use Rails logger if it exists
  
0.4.0
  
  - removed notification wrapper around messages sent to Chatterbox to simplify things
  