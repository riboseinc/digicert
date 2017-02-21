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
end
