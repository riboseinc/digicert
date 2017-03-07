module Digicert
  module Errors
    class Unauthorized < RequestError
      def explanation
        "A request to Digicert API was sent without a valid authentication"
      end
    end
  end
end
