require "spec_helper"

RSpec.describe Digicert::EmailValidation do
  describe ".all" do
    it "retrieves the list of email with validation status" do
      order_id = 123_456_789

      stub_digicert_email_validations_api(order_id)
      email_validations = Digicert::EmailValidation.all(order_id: order_id)

      expect(email_validations.first.status).to eq("validated")
      expect(email_validations.first.email).to eq("email@example.com")
    end
  end

  describe ".valid?" do
    it "validates the email through digicert" do
      validation_attributes = { token: "token", email: "email@example.com" }
      stub_digicert_email_validations_validate_api(validation_attributes)

      expect(
        Digicert::EmailValidation.valid?(validation_attributes),
      ).to eq(true)
    end
  end
end
