require "spec_helper"

RSpec.describe Digicert::ContainerTemplate do
  describe ".all" do
    it "retrieves the list of all container tempaltes" do
      container_id = 123_456_789

      stub_digicert_container_template_list_api(container_id)
      container_templates = Digicert::ContainerTemplate.all(container_id)

      expect(container_templates.count).to eq(2)
      expect(container_templates.first.id).not_to be_nil
      expect(container_templates.first.name).not_to be_nil
    end
  end

  describe ".fetch" do
    it "retrieves the specific container tempalte" do
      template_id = 987_654_321
      container_id = 123_456_789
      stub_digicert_container_template_fetch_api(template_id, container_id)

      container_template = Digicert::ContainerTemplate.fetch(
        container_id: container_id, template_id: template_id,
      )

      expect(container_template.id).not_to be_nil
      expect(container_template.name).not_to be_nil
      expect(container_template.access_roles.first.name).to eq("Administrator")
    end
  end
end
