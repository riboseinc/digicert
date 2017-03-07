module Digicert
  module Errors
    class Forbidden < RequestError
      def explanation
        "A request to Digicert API was considered forbidden by the server"
      end
    end
  end
end
