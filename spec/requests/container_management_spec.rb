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

  def container_id
    @container_id ||= ENV["DIGICERT_CONTAINER_ID"]
  end
end
