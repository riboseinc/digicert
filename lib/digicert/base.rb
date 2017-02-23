require "digicert/request"
require "digicert/actions/all"
require "digicert/actions/fetch"

module Digicert
  class Base
    include Digicert::Actions::All
    include Digicert::Actions::Fetch

    def initialize(attributes = {})
      @attributes = attributes
      @query_params = @attributes.delete(:params)
      @resource_id = @attributes.delete(:resource_id)
    end

    private

    attr_reader :attributes, :resource_id, :query_params

    def resources_key
      [resource_path, "s"].join
    end

    def resource_creation_path
    end
  end
end
