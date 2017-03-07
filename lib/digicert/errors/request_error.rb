module Digicert
  module Errors
    class RequestError < StandardError
      def message
        explanation
      end

      def explanation
        "A request to Digicert API failed"
      end
    end
  end

  Error = Errors::RequestError
end
