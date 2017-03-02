require "digicert/actions/base"

module Digicert
  module Actions
    module Create
      extend Digicert::Actions::Base

      def create
        Digicert::Request.new(
          :post, resource_creation_path, validate(attributes),
        ).parse
      end

      def resource_creation_path
        resource_path
      end

      module ClassMethods
        def create(attributes)
          new(attributes).create
        end
      end
    end
  end
end
