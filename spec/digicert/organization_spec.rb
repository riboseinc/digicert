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

  describe ".create" do
    it "creates a new organization" do
      stub_digicert_organization_create_api(organization_attributes)
      organization = Digicert::Organization.create(organization_attributes)

      expect(organization.id).not_to be_nil
    end
  end

  describe ".fetch" do
    it "retrieves the specified organization details" do
      organization_id = 123_456_789

      stub_digicert_organization_fetch_api(organization_id)
      organization = Digicert::Organization.fetch(organization_id)

      expect(organization.id).not_to be_nil
      expect(organization.name).not_to be_nil
      expect(organization.container.id).not_to be_nil
    end
  end

  def organization_attributes
    {
      name: "digicert, inc.",
      address: "333 s 520 w",
      zip: 84042,
      city: "lindon",
      state: "utah",
      country: "us",
      telephone: 8015551212,
      container: { id: 17 },

      organization_contact: {
        first_name: "Some",
        last_name: "Guy",
        email: "someguy@digicert.com",
        telephone: 8015551212,
      },

      # Optional attributes
      assumed_name: "DigiCert",
      address2: "Suite 500",
    }
  end
end
