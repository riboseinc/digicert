require "digicert/actions/base"

module Digicert
  module Actions
    module All
      extend Digicert::Actions::Base

      def all
        response = Digicert::Request.new(:get, resource_path).run
        response[resources_key]
      end

      module ClassMethods
        def all
          new.all
        end
      end
    end
  end
end
