require "spec_helper"

RSpec.describe "Organization Management" do
  describe "fetching an organization", api_call: true do
    it "fetches the organization details" do
      organizations = Digicert::Organization.all
      organization = Digicert::Organization.fetch(organizations.first.id)

      expect(organization.name).to eq("Ribose Inc.")
      expect(organization.id).to eq(organization_id)
      expect(organization.container.id).to eq(container_id)
    end
  end

  def container_id
    @container_id ||= ENV["DIGICERT_CONTAINER_ID"].to_i
  end

  def organization_id
    @organization_id ||= ENV["DIGICERT_ORGANIZATION_ID"].to_i
  end
end
