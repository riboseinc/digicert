require "spec_helper"

RSpec.describe Digicert::Domain do
  describe ".create" do
    it "creates a new domain for an organization" do
      stub_digicert_domain_create_api(domain_attributes)
      domain = Digicert::Domain.create(domain_attributes)

      expect(domain.id).not_to be_nil
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
