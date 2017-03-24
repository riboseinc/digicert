require "digicert/config"

module Digicert
  module Errors
    class RequestError < StandardError
      def initialize(msg = {})
        @msg = msg
        super msg
      end

      def message
        <<-MSG.gsub(/^ {8}/, '')
        #{explanation}:
        #{response_body}
        MSG
      end

      def explanation
        "A request to Digicert API failed"
      end

      def kind
        response_body.fetch("code", {})
      end

      private

      attr_reader :msg

      def response_body
        JSON[msg] rescue {}
      end
    end
  end

  Error = Errors::RequestError
end
