require "spec_helper"
require "digicert"

RSpec.describe "Download a certificate" do
  it "creates and download a certificate" do
    name_id = "ssl_plus"

    # Retrieve the product details uisng the
    # name id specificed for that specific one
    #
    stub_digicert_product_fetch_api(name_id)
    product = Digicert::Product.fetch(name_id)

    # Order a new certificate using the product details
    # server platform, signature hash and other fields
    #
    order_attributes = build_order_attributes(product)
    stub_digicert_order_create_api("ssl_plus", order_attributes)
    order = Digicert::Order.create("ssl_plus", order_attributes)

    # Retrieve the certificate order details with the
    # certificate id in it, so we can use this one to
    # download the certificate using the API
    #
    stub_digicert_certificate_order_fetch_api(order.id)
    certificate_order = Digicert::CertificateOrder.fetch(order.id)

    expect(certificate_order.certificate.id).not_to be_nil
  end

  def build_order_attributes(product)
    {
      certificate: {
        organization_units: ["Developer Operations"],
        server_platform: { id: product.server_platforms.first.id },
        profile_option: "some_ssl_profile",

        csr: "------ [CSR HERE] ------",
        common_name: "digicert.com",
        signature_hash: product.signature_hash_types.allowed_hash_types[0].id,
      },
      organization: { id: organizations.first.id },
      validity_years: product.allowed_validity_years.last,
      disable_renewal_notifications: false,
      renewal_of_order_id: 314152,
      payment_method: "balance",
    }
  end

  def organizations
    stub_digicert_organization_list_api
    Digicert::Organization.all
  end
end
