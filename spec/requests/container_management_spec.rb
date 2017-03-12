require "spec_helper"

RSpec.describe "Container Management" do
  describe "fetching a container template", api_call: true do
    it "fetches the first container template details" do
      templates = Digicert::ContainerTemplate.all(container_id)
      template = Digicert::ContainerTemplate.fetch(
        template_id: templates.first.id, container_id: container_id,
      )

      expect(template.name).to eq("Business Unit")
      expect(template.access_roles.first.name).to eq("Administrator")
    end
  end

  describe "fetching a container details", api_call: true do
    it "retrieves the details for a container" do
      container = Digicert::Container.fetch(container_id)

      expect(container.is_active).to eq(true)
      expect(container.name).to eq("Ribose Inc.")
    end
  end

  def container_id
    @container_id ||= containers.first.id
  end

  def containers
    # We are making this API call intentionally, this
    # ensures the listing containers API is working as
    # it should have as long as there are no errors.
    #
    @containers ||= Digicert::Container.all
  end
end
