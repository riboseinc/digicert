require "digicert/base"
require "digicert/actions/create"

module Digicert
  class Container < Digicert::Base
    include Digicert::Actions::Create

    def self.create(container_id:, **attributes)
      new(attributes.merge(container_id: container_id)).create
    end

    private

    def extract_local_attribute_ids
      @container_id = attributes.delete(:container_id)
    end

    def validate(name:, template_id:, **attributes)
      required_attributes = {
        name: name, template_id: template_id
      }

      required_attributes.merge(attributes)
    end

    def resource_path
      "container"
    end

    def resource_creation_path
      [resource_path, @container_id, "children"].join("/")
    end
  end
end
