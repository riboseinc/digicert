require "spec_helper"

RSpec.describe "Reissuing Certificate" do
  describe "reissue" do
    it "reissues an existing nonexpired certificate", api_call: true do
      # This tests will find the last created certificate order and
      # then will try to reissue that, but one important thing to note
      # that digicert only allows expects active certificate to reissue
      # and normally every certificate in test environment gets expired
      # in 3 days.
      #
      # So, if this fails, then please to run the certificate generation
      # test first, which will create a new order and then try this agian
      # and it should work like a charm
      #
      reissue = Digicert::OrderReissuer.create(order_id: recent_order.id)

      # Let's fetch the details for the new request and that way we can
      # verify that this reissues has the proper request type and then
      # we can do the further tasks on it.
      #
      request_id = reissue.requests.first.id
      certificate_request = Digicert::CertificateRequest.fetch(request_id)

      expect(reissue.id).to eq(recent_order.id)
      expect(certificate_request.type).to eq("reissue")
    end
  end

  def recent_order
    @recent_order ||= orders.first
  end

  def orders
    @orders ||= Digicert::Order.all
  end
end
