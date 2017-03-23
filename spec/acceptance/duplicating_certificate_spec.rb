require "spec_helper"

RSpec.describe "Certificate Order Duplication" do
  it "duplicates and download a certificate" do
    name_id = "ssl_plus"

    # Create a new order for a specific product
    # and it usages the attributes form a helper
    #
    stub_digicert_order_create_api(name_id, order_attributes)
    order = Digicert::Order.create(name_id, order_attributes)

    # Duplicate the certificate order
    # We have the order id from the previous order
    # creation interface, let's use that to duplicate
    # the certificate order
    #
    order_obj = Digicert::Order.find(order.id)
    stub_digicert_order_duplicate_api(order.id, certificate_attributes)
    duplicate_order = order_obj.duplicate(certificate_attributes)

    # Retrieve the request details from the
    # Order Reissuing requests, if it needs further
    # processing then we can use that id to do that
    #
    request_id = duplicate_order.requests.first.id
    stub_digicert_certificate_request_fetch_api(request_id)
    request = Digicert::CertificateRequest.fetch(request_id)

    # We can recheck the request status, and once that
    # is approved (manually/using the interface), then
    # we can use that to retrieve the order details
    #
    stub_digicert_order_fetch_api(request.order.id)
    certificate_order = Digicert::Order.fetch(request.order.id)

    # Finally we can use that certificate id from that
    # certificate_order's certificate and then we can
    # write it to some files.
    #
    certificate_id = certificate_order.certificate.id
    stub_digicert_certificate_download_by_platform(certificate_id)
    certificate = Digicert::CertificateDownloader.fetch(certificate_id)

    expect(certificate.code.to_i).to eq(200)
    expect(certificate.body.start_with?("PK")).to be_truthy
  end

  def order_attributes
    {
      certificate: {
        organization_units: ["Developer Operations"],
        server_platform: { id: "platform_id" },
        profile_option: "some_ssl_profile",

        csr: "------ [CSR HERE] ------",
        common_name: "digicert.com",
        signature_hash: "sha256",
      },
      organization: { id: 123_456 },
      validity_years: 1,
      disable_renewal_notifications: false,
      renewal_of_order_id: 314152,
      payment_method: "balance",
    }
  end

  def certificate_attributes
    {
      certificate: {
        common_name: order.certificate.common_name,
        dns_names: order.certificate.dns_names,
        csr: order.certificate.csr,
        signature_hash: order.certificate.signature_hash,
        server_platform: { id: order.certificate.server_platform.id },
      }
    }
  end

  def order
    order_id = 542772

    stub_digicert_order_fetch_api(order_id)
    @order ||= Digicert::Order.fetch(order_id)
  end
end
