require "spec_helper"

RSpec.describe "Domain Management" do
  describe "managing a domains", api_call: true do
    it "create, activate and deactives a domain" do
      # Create a new domain using the `.create` interface,
      # please remember if the domain is already exists then
      # it will return that domain object, but if not then it
      # will create add a new domain to your organization.
      #
      domain = Digicert::Domain.create(domain_attributes)

      # Let's play with the domain, let's try to deactivate
      # first and then reactivate it.
      domain = Digicert::Domain.find(domain.id)

      # Deactivate the domain
      domain.deactivate

      # Reactivate the domain
      domain.activate

      # Refresh the doamin we have been dealing with, and this
      # call will also ensures the `fetch` api is working as
      # expcted as long as it does not fails
      #
      domain = domain.fetch

      expect(domain.is_active).to eq(true)
      expect(domain.id).to eq(domains.last.id)
      expect(domain.name).to eq(ribose_test_domain)
      expect(domain.organization.name).to eq("Ribose Inc.")
    end
  end

  def ribose_test_domain
    @ribose_test_domain ||= "ribose.test"
  end

  def domain_attributes
    {
      dcv: { method: "email" },
      name: ribose_test_domain,
      organization: { id: organization_id },
      validations: [{ type: "OV", user: { id: administrator_id }}],
    }
  end

  def domains
    # Call to this method will peform an actual API call
    # to list all the existing domains, so returning the
    # correct response ensures the `.all` interface is ok.
    #
    @domains ||= Digicert::Domain.all
  end

  def organization_id
    ENV["DIGICERT_ORGANIZATION_ID"]
  end

  def administrator_id
    ENV["DIGICERT_ADMINISTRATOR_ID"]
  end
end
