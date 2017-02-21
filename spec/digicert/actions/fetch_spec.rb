require "spec_helper"
require "digicert/base"

RSpec.describe "Digicert::Actions::Fetch" do
  describe ".fetch" do
    it "fetch a specified resource" do
      resource_id = 123_456_789

      stub_digicert_container_fetch_api(resource_id)
      resource = Digicert::TestFetchAction.fetch(resource_id)

      expect(resource.id).not_to be_nil
      expect(resource.name).not_to be_nil
    end
  end

  module Digicert
    class TestFetchAction < Digicert::Base
      private

      def resource_path
        "container"
      end
    end
  end
end
