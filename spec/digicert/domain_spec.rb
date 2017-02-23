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

  def domain_attributes
    {
      name: "digicert.com",
      organization: { id: 117483 },
      validations: [
        {
          type: "ev",
          user: { id: 12 }
        },
      ],
      dcv: { method: "email" },
    }
  end
end
