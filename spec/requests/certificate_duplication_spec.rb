require "spec_helper"

RSpec.describe "Certificate Duplication" do
  describe "duplicate an existing certificate", api_call: true do
    it "duplicates an existing nonexpired certificate order" do
      duplication = Digicert::OrderDuplicator.create(order_id: recent_order.id)
      duplicate_certificate = Digicert::DuplicateCertificateFinder.find_by(
        request_id: duplication.requests.first.id,
      )

      expect(
        order.duplicate_certificates.map(&:id),
      ).to include(duplicate_certificate.id)
    end
  end

  # Create a order class instance
  #
  # This helper create an instance for the order, so we can invoke the
  # order's instance method to access the duplicate certificates
  #
  def order
    @order ||= Digicert::Order.find(recent_order.id)
  end

  # Recent order
  #
  # All of the certifacate are not duplicable, from the test we can say
  # for sure that the wilcard certifacate are duplicable. This spec assume
  # the last order to be a ssl wildcard, if it fails then please run the
  # `order_ssl_wildcard` request specs to create one and then re-run this
  # spec again.
  #
  def recent_order
    @recent_order ||= orders.first
  end

  def orders
    Digicert::Order.all
  end
end
