require "cgi"
require "spec_helper"

RSpec.describe Digicert::Util do
  describe ".to_query" do
    context "plain hash with key and value" do
      it "builds and returns the queryable params" do
        params = { limit: 10, sort: "date_created" }
        query_params = Digicert::Util.to_query(params)

        expect(query_params).to eq("limit=10&sort=date_created")
      end
    end

    context "with nested hash as key" do
      it "resolves it and returns the queryable params" do
        params = { limit: 10, filters: { status: "issued", search: "ribose" } }
        query_params = Digicert::Util.to_query(params)

        expect(
          CGI.unescape(query_params),
        ).to eq("limit=10&filters[status]=issued&filters[search]=ribose")
      end
    end
  end
end
