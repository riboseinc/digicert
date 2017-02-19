require "spec_helper"

RSpec.describe Digicert::Organization do
  describe ".all" do
    it "retrieves the list of organizations" do
      stub_digicert_organization_list_api
      organizations = Digicert::Organization.all

      expect(organizations.first.id).not_to be_nil
      expect(organizations.first.name).not_to be_nil
      expect(organizations.first.is_active).to eq(true)
      expect(organizations.first.container.id).not_to be_nil
    end
  end
end
