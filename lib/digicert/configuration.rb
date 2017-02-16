module Digicert
  class Configuration
    attr_accessor :api_host, :base_path

    def initialize
      @api_host = "www.digicert.com"
      @base_path = "services/v2"
    end
  end
end
