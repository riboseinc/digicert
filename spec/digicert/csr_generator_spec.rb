require "spec_helper"

RSpec.describe Digicert::CSRGenerator do
  describe ".generate" do
    it "returns the generated csr content" do
      csr = Digicert::CSRGenerator.generate(
        rsa_key: rsa_key_content,
        organization: ribose_inc,
        common_name: "ribosetest.com",
      )

      expect(csr.start_with?("-----BEGIN CERTIFICATE REQUEST")).to be_truthy
      expect(csr.end_with?("--END CERTIFICATE REQUEST-----\n")).to be_truthy
    end
  end

  def rsa_key_content
    rsa_key_path = "../../fixtures/rsa4096.key"
    File.read(File.expand_path(rsa_key_path, __FILE__))
  end

  def ribose_inc
    double(
      "Digicert::Organization",
      name: "Ribose Inc.",
      city: "Wilmington",
      state: "Delaware",
      country: "us",
    )
  end
end
