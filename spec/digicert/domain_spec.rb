require "spec_helper"

RSpec.describe Digicert::Domain do
  describe ".create" do
    it "creates a new domain for an organization" do
      stub_digicert_domain_create_api(domain_attributes)
      domain = Digicert::Domain.create(domain_attributes)

      expect(domain.id).not_to be_nil
    end
  end

  describe ".all" do
    context "without any filters" do
      it "retrieves the list of domains" do
        stub_digicert_domain_list_api
        domains = Digicert::Domain.all

        expect(domains.count).to eq(2)
        expect(domains.first.id).not_to be_nil
        expect(domains.first.name).not_to be_nil
      end
    end

    context "with custom filters" do
      it "retrieves the filtered list" do
        filter_params = { container_id: 123 }
        stub_digicert_domain_list_api(filter_params)
        domains = Digicert::Domain.all(filter_params)

        expect(domains.count).to eq(2)
        expect(domains.first.id).not_to be_nil
        expect(domains.first.name).not_to be_nil
      end
    end
  end

  describe ".fetch" do
    it "retrieves the specific domain" do
      domain_id = 123_456_789
      filters = { include_dcv: true, include_validation: true }

      stub_digicert_domain_fetch_api(domain_id, filters)
      domain = Digicert::Domain.fetch(domain_id, filters)

      expect(domain.id).not_to be_nil
      expect(domain.dcv.name_scope).not_to be_nil
      expect(domain.validations.first.type).to eq("ev")
    end
  end

  describe "#activate" do
    it "activates a specific domain" do
      domain_id = 123_456_789
      domain = Digicert::Domain.find(domain_id)

      stub_digicert_domain_activate_api(domain_id)
      domain_activation = domain.activate

      expect(domain_activation.code).to eq("204")
    end
  end

  describe "#deactivate" do
    it "deactivates a specific domain" do
      domain_id = 123_456_789
      domain = Digicert::Domain.find(domain_id)

      stub_digicert_domain_deactivate_api(domain_id)
      domain_deactivation = domain.deactivate

      expect(domain_deactivation.code).to eq("204")
    end
  end

  def domain_attributes
    {
      name: "digicert.com",
      organization: { id: 117483 },
      validations: [
        {
          user: { id: 12 },
          type: "ev",
        },
      ],
      dcv: { method: "email" },
    }
  end
end
