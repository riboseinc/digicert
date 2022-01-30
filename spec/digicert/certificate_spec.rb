require "spec_helper"

RSpec.describe Digicert::Certificate do
  describe ".find" do
    it "creates a certificate instance" do
      certificate_id = 123_456_789
      certificate = Digicert::Certificate.find(certificate_id)

      expect(certificate.class).to eq(Digicert::Certificate)
    end
  end

  describe "#download" do
    context "when format specified" do
      it "fetches the certificate using the format" do
        certificate_id = 123_456_789
        certificate = Digicert::Certificate.find(certificate_id)
        allow(Digicert::CertificateDownloader).to receive(:fetch)

        certificate.download(format: "zip")

        expect(
          Digicert::CertificateDownloader,
        ).to have_received(:fetch).with(certificate_id, format: "zip")
      end
    end

    context "when platform specified" do
      it "fetches the certificate using the platform" do
        certificate_id = 123_456_789
        certificate = Digicert::Certificate.find(certificate_id)
        allow(Digicert::CertificateDownloader).to receive(:fetch)

        certificate.download(platform: "apache")

        expect(
          Digicert::CertificateDownloader,
        ).to have_received(:fetch).with(certificate_id, platform: "apache")
      end
    end
  end

  describe "#download_to_path" do
    it "downloads and wrtites the certificate to the path" do
      certificate_id = 123_456_789
      certificate = Digicert::Certificate.find(certificate_id)
      allow(File).to receive(:open)

      download_to_path_attributes = {
        ext: "zip",
        path: File.expand_path("../../../tmp", __FILE__),
      }

      stub_digicert_certificate_download_by_platform(certificate_id)
      certificate.download_to_path(**download_to_path_attributes)

      download_url =
        [download_to_path_attributes[:path], "certificate.zip"].join("/")

      expect(File).to have_received(:open).with(download_url, "w")
    end
  end

  describe "#download_content" do
    it "sends fetch_content message to the downloader" do
      certificate_id = 123_456_789
      certificate = Digicert::Certificate.find(certificate_id)
      allow(Digicert::CertificateDownloader).to receive(:fetch_content)

      certificate.download_content

      expect(
        Digicert::CertificateDownloader,
      ).to have_received(:fetch_content).with(certificate_id)
    end
  end

  describe "#revoke" do
    it "revokes an existing certificate" do
      certificate_id = 123_456_789
      comments = "I no longer need this cert."
      stub_digicert_certificate_revoke_api(certificate_id, comments: comments)

      revocation = Digicert::Certificate.revoke(
        certificate_id, comments: comments
      )

      expect(revocation.id).not_to be_nil
      expect(revocation.type).to eq("revoke")
      expect(revocation.status).to eq("pending")
    end
  end
end
