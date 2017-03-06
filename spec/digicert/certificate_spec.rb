require "spec_helper"

RSpec.describe Digicert::Certificate do
  describe ".find" do
    it "creates a certificate instance" do
      certificate_id = 123_456_789
      certificate = Digicert::Certificate.find(certificate_id)

      expect(certificate.class).to eq(Digicert::Certificate)
    end
  end

  describe "#revoke" do
    it "revokes an existing certificate" do
      certificate_id = 123_456_789
      comments = "I no longer need this cert."
      stub_digicert_certificate_revoke_api(certificate_id, comments: comments)

      revocation = Digicert::Certificate.revoke(
        certificate_id, comments: comments,
      )

      expect(revocation.id).not_to be_nil
      expect(revocation.type).to eq("revoke")
      expect(revocation.status).to eq("pending")
    end
  end
end
