require "spec_helper"

RSpec.describe "Domain Management" do
  describe "managing a domains", api_call: true do
    it "activates/deactives a domain" do
      domain = Digicert::Domain.find(domain_id)

      # Deactivate the domain
      domain.deactivate

      # Reactivate the domain
      domain.activate

      # Fetch the doamin we have been dealing with, and this
      # call will also ensures the `fetch` api is working as
      # expcted as long as it does not fails
      #
      domain = Digicert::Domain.fetch(domain_id)

      expect(domain.is_active).to eq(true)
      expect(domain.name).to eq("ribose.test")
      expect(domain.organization.name).to eq("Ribose Inc.")
    end
  end

  def domain_id
    @domain_id ||= domains.last.id
  end

  def domains
    # Call to this method will peform an actual API call
    # to list all the existing domains, so returning the
    # correct response ensures the `.all` interface is ok.
    #
    @domains ||= Digicert::Domain.all
  end
end
