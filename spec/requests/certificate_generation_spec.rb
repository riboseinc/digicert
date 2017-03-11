require "spec_helper"

RSpec.describe "Certificate Generation" do
  describe "generation process", api_call: true do
    it "creates and download a certificate" do
      product_name_id = "ssl_plus"

      # Retrieve the product details uisng the
      # name id specificed for that specific one
      #
      product = Digicert::Product.fetch(product_name_id)

      # Reqeust a new certificate using the order creation
      # interface by providing t`name_id` and required attributes
      #
      order_request = Digicert::Order.create(
        product.name_id, order_attributes
      )

      # Retrieve order details using the order_request id as
      # it should contains the `certifcate`, so we then can
      # download the generated certificate
      #
      order = Digicert::Order.fetch(order_request.id)

      # Digicert requires some time to issue the certificate, but it's
      # pretty quick in the development environment and typilcally it
      # issues within couple of seconds. Let's order status and if that
      # has not been issued yet then let's wait 10 seconds in dev env.
      #
      # In the production use please use the `Digicert::Reqeust` incase
      # you need to do anything related to the request.
      #
      if order.status != "issued"
        sleep 10
      end

      # Now that we have the certicate orders detials with
      # the certificate id and the order status, so let's assume
      # all requiremetns are meet and let's fetch the certificate
      #
      certificate_id = order.certificate.id
      certificate = Digicert::Certificate.find(certificate_id)
      certificate_content = certificate.download

      # Let's also cleanup the certifcate by requesting and approving
      # the revocation for the certificate.
      certifcate.revoke

      # Normally zip archieves content starts with `PK` and then
      # the content of the files inside the zip folder
      #
      # Source: http://filext.com/faq/look_into_files.php
      #
      expect(certificate_content.body.start_with?("PK")).to be_truthy
    end
  end

  def common_name
    "test.ribosetest.com"
  end

  def ribose_inc
    @ribose_inc ||= organizations.first
  end

  def order_attributes
    {
      validity_years: 1,
      certificate: certificate_attributes,
      organization: { id: ribose_inc.id },
    }
  end

  def certificate_attributes
    {
      common_name: common_name,
      csr: csr_content_for_ribosetest.to_s,
      signature_hash: "sha256",
      server_platform: { id: 2 },
    }
  end

  def csr_content_for_ribosetest
    @csr_content ||= Digicert::CSRGenerator.generate(
      domain: common_name, organization: ribose_inc,
    )
  end

  def organizations
    Digicert::Organization.all
  end
end
