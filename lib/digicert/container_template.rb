require "digicert/base"

module Digicert
  class ContainerTemplate < Base
    include Digicert::Actions::All
    include Digicert::Actions::Fetch

    def self.all(container_id)
      new(container_id: container_id).all
    end

    def self.fetch(template_id:, container_id:)
      new(resource_id: template_id, container_id: container_id).fetch
    end

    private

    def extract_local_attribute_ids
      @container_id = attributes.delete(:container_id)
    end

    def resources_key
      "container_templates"
    end

    def resource_path
      ["container", @container_id, "template"].join("/")
    end
  end
end
