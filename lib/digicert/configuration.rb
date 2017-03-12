module Digicert
  class Configuration
    attr_accessor :api_key, :api_host, :base_path, :response_type, :debug_mode

    def initialize
      @api_host = "www.digicert.com"
      @base_path = "services/v2"
      @response_type = :object
      @debug_mode = false
    end

    def response_klass
      response_klasses[response_type.to_sym] || ResponseObject
    end

    def debug_mode?
      debug_mode == true
    end

    private

    def response_klasses
      { hash: Hash, object: ResponseObject }
    end
  end
end
