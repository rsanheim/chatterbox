module Chatterbox # :nodoc:
  module Version # :nodoc:
    unless defined?(MAJOR)
      MAJOR  = 0
      MINOR  = 8
      TINY   = 4

      STRING = [MAJOR, MINOR, TINY].compact.join('.')

      SUMMARY = "chatterbox " + STRING
    end
  end
end
