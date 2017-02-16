require "digicert/configuration"

module Digicert
  module Config
    def configure
      if block_given?
        yield configuration
      end
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end

  # Expose config module methodas as class level method,
  # so we can use those method whenever necessary, specially
  # the `configuration` throughout the gem
  #
  extend Config
end
