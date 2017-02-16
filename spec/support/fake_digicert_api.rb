module Digicert
  module FakeDigicertApi
    def stub_digicert_product_list_api
      stub_api_response(
        :get, "product", filename: "products", status: 200,
      )
    end

    def stub_digicert_product_fetch_api(name_id)
      stub_api_response(
        :get, ["product", name_id].join("/"), filename: "product", status: 200,
      )
    end

    def stub_api_response(method, end_point, filename:, status: 200, data: nil)
      stub_request(method, digicert_api_end_point(end_point)).
        with(digicert_api_request_headers(data: data)).
        to_return(response_with(filename: filename, status: status))
    end

    private

    def digicert_api_end_point(end_point)
      ["https://www.digicert.com/services/v2", end_point].join("/")
    end

    def digicert_api_request_headers(data: nil)
      Hash.new.tap do |request_headers|
        request_headers[:headers] = api_key_header
        unless data.nil?
          request_headers[:body] = data.to_json
        end
      end
    end

    def response_with(filename:, status:)
      { body: digicert_fixture(filename), status: status }
    end

    def api_key_header
      { "X-DC-DEVKEY" => Digicert.configuration.api_key }
    end

    def digicert_fixture(filename)
      file_name = [filename, "json"].join(".")
      file_path = ["../../", "fixtures", file_name].join("/")

      File.read(File.expand_path(file_path, __FILE__))
    end
  end
end
