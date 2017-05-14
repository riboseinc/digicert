require "spec_helper"
require "digicert/base"

RSpec.describe "Digicert::Actions::ALL" do
  describe ".all" do
    context "with out query param" do
      it "retrieves the list of resources" do
        stub_digicert_organization_list_api
        organizations = Digicert::TestAllAction.all

        expect(organizations.count).to eq(2)
        expect(organizations.first.name).not_to be_nil
      end
    end

    context "with specificed query params" do
      it "pass the params and retrieve the list of resources" do
        query_params = { limit: 2, offset: 0, sort: "date_created" }

        stub_digicert_organization_list_api(query_params)
        organizations = Digicert::TestAllAction.all(query_params)

        expect(organizations.count).to eq(2)
        expect(organizations.first.name).not_to be_nil
      end
    end
  end

  module Digicert
    class TestAllAction < Digicert::Base
      include Digicert::Actions::All

      private

      def resource_path
        "organization"
      end
    end
  end
end
