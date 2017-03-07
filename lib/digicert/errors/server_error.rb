module Digicert
  module Errors
    class ServerError < RequestError
      def explanation
        "A request to Digicert API caused an unexpected server error"
      end
    end
  end
end
