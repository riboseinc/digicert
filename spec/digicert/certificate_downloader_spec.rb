require "spec_helper"

RSpec.describe Digicert::CertificateDownloader do
  describe ".fetch" do
    it "retrives the certificate contents" do
      certificate_id = 123_456_789

      stub_digicert_certificate_download_by_platform(certificate_id)
      certificate = Digicert::CertificateDownloader.fetch(certificate_id)

      expect(certificate.code.to_i).to eq(200)
      expect_certficate_to_be_a_zip_archieve(certificate)
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
