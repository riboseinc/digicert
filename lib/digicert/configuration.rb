module Digicert
  class Configuration
    attr_accessor :api_key, :api_host, :base_path, :response_type

    def initialize
      @api_host = "www.digicert.com"
      @base_path = "services/v2"
      @response_type = :object
    end

    def response_klass
      response_klasses[response_type.to_sym] || ResponseObject
    end

    private

    def response_klasses
      { hash: Hash, object: ResponseObject }
    end
  end
end
