require "spec_helper"

RSpec.describe Digicert::CertificateDownloader do
  describe ".fetch" do
    it "retrives the certificate contents" do
      certificate_id = 123_456_789
      platform = "apache"
      stub_digicert_certificate_download_by_platform(certificate_id, platform)

      certificate = Digicert::CertificateDownloader.fetch(
        certificate_id, platform: platform,
      )

      expect(certificate.code.to_i).to eq(200)
      expect_certficate_to_be_a_zip_archieve(certificate)
    end
  end

  describe ".fetch_to_path" do
    it "fetch and write that to a file" do
      certificate_id = 123_456_789
      allow(File).to receive(:open)
      download_path = File.expand_path("../../../tmp", __FILE__)

      stub_digicert_certificate_download_by_platform(certificate_id)
      Digicert::CertificateDownloader.fetch_to_path(
        certificate_id, path: download_path, ext: "zip",
      )

      download_url = [download_path, "certificate.zip"].join("/")
      expect(File).to have_received(:open).with(download_url, "w")
    end
  end

  describe ".fetch_by_platform" do
    it "retrieves a certificate by specified platform" do
      platform = "apache"
      certificate_id = 123_456_789

      stub_digicert_certificate_download_by_platform(certificate_id, platform)
      certificate = Digicert::CertificateDownloader.fetch_by_platform(
        certificate_id, platform: platform,
      )

      expect(certificate.code.to_i).to eq(200)
      expect_certficate_to_be_a_zip_archieve(certificate)
    end
  end

  describe ".fetch_by_format" do
    it "retrives a certificate by specified format" do
      format = "pem"
      certificate_id = 123_456_789

      stub_digicert_certificate_download_by_format(certificate_id, format)
      certificate = Digicert::CertificateDownloader.fetch_by_format(
        certificate_id, format: format,
      )

      expect(certificate.code.to_i).to eq(200)
      expect_certficate_to_be_a_zip_archieve(certificate)
    end
  end

  describe ".fetch_content" do
    it "retrives the certificate and extract the content to hash" do
      cert_id = 123_456_789

      stub_digicert_certificate_download_by_format(cert_id, "pem_all", "pem")
      certificate = Digicert::CertificateDownloader.fetch_content(cert_id)

      expect(certificate[:certificate]).not_to be_nil
      expect(certificate[:root_certificate]).not_to be_nil
      expect(certificate[:intermediate_certificate]).not_to be_nil
    end
  end

  def expect_certficate_to_be_a_zip_archieve(certificate)
    # The response we get from the certificate downloader is
    # a file, and it's a `.zip` to be more specific. The easiest
    # way to verify if it's a .zip file or not is not check the
    # file content, and if it starts with `PK` then it is more
    # likely a zip archieve
    #
    # Source: http://filext.com/faq/look_into_files.php
    #
    expect(certificate.body.start_with?("PK")).to eq(true)
  end
end
