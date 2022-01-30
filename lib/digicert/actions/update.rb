require "digicert/actions/base"

module Digicert
  module Actions
    module Update
      extend Digicert::Actions::Base

      def update
        Digicert::Request.new(
          :put, resource_update_path, **attributes
        ).run
      end

      def resource_update_path
        [resource_path, resource_id].join("/")
      end

      module ClassMethods
        def update(resource_id, attributes)
          new(resource_id: resource_id, **attributes).update
        end
      end
    end
  end
end
