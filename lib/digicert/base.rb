require "digicert/request"
require "digicert/actions/all"
require "digicert/actions/fetch"

module Digicert
  class Base
    include Digicert::Actions::All
    include Digicert::Actions::Fetch

    def initialize(resource_id: nil, **attributes)
      @resource_id = resource_id
      @attributes = attributes
    end

    private

    attr_reader :resource_id, :attributes

    def resources_key
      [resource_path, "s"].join
    end
  end
end
