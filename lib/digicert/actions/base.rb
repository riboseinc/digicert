require "digicert/request"

module Digicert
  module Actions
    module Base
      def included(base)
        base.extend(const_get(:ClassMethods))
      end
    end
  end
end
