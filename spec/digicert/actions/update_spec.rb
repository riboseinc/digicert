require "spec_helper"
require "digicert/base"
require "digicert/actions/update"

RSpec.describe "Digicert::Actions::Update" do
  describe ".update" do
    it "updates the resource attributes" do
      resource_id = 123_456_789
      stub_digicert_certificate_request_update_api(
        resource_id, certificate_status_attributes,
      )

      resource = Digicert::TestUpdateAction.update(
        resource_id, certificate_status_attributes,
      )

      expect(resource.code.to_i).to eq(204)
    end
  end

  module Digicert
    class TestUpdateAction < Digicert::Base
      include Digicert::Actions::Update

      private

      def resource_update_path
        ["request", resource_id, "status"].join("/")
      end
    end
  end

  def certificate_status_attributes
    {
      status: "approved",
      processor_comment: "Your domain is approved",
    }
  end
end
