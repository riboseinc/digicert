require "spec_helper"

RSpec.describe Digicert::CertificateDownloader do
  describe ".fetch" do
    it "retrives the certificate contents" do
      certificate_id = 123_456_789

      stub_digicert_certificate_content_fetch_api(certificate_id)
      certificate = Digicert::CertificateDownloader.fetch(certificate_id)

      # The response we get from the certificate downloader is
      # a file, and it's a `.zip` to be more specific. The easiest
      # way to verify if it's a .zip file or not is not check the
      # file content, and if it starts with `PK` then it is more
      # likely a zip archieve
      #
      # Source: http://filext.com/faq/look_into_files.php
      #
      expect(certificate.code.to_i).to eq(200)
      expect(certificate.body.start_with?("PK")).to eq(true)
    end
  end
end
