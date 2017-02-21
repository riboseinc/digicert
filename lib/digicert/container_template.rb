require "digicert/base"

module Digicert
  class ContainerTemplate < Base
    def initialize(container_id:, resource_id: nil)
      @resource_id = resource_id
      @container_id = container_id
    end

    def self.all(container_id)
      new(container_id: container_id).all
    end

    def self.fetch(template_id:, container_id:)
      new(resource_id: template_id, container_id: container_id).fetch
    end

    private

    def resources_key
      "container_templates"
    end

    def resource_path
      ["container", @container_id, "template"].join("/")
    end
  end
end
