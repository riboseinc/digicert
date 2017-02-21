require "digicert/base"

module Digicert
  class Container < Digicert::Base
    def initialize(attributes = {})
      @resource_id = attributes[:resource_id]
      @container_id = attributes[:container_id]
    end

    def create(name:, template_id:, **attributes)
      required_attributes = {
        name: name, template_id: template_id
      }

      create_container(required_attributes, attributes)
    end

    def self.create(container_id:, **attributes)
      new(container_id: container_id).create(attributes)
    end

    private

    def create_container(required_attrs, additional_attrs)
      Digicert::Request.new(
        :post, container_creation_path, required_attrs.merge(additional_attrs),
      ).run
    end

    def container_creation_path
      [resource_path, @container_id, "children"].join("/")
    end

    def resource_path
      "container"
    end
  end
end
