module Digicert
  module FakeDigicertApi
    def stub_digicert_product_list_api
      stub_api_response(
        :get, "product", filename: "products", status: 200
      )
    end

    def stub_digicert_product_fetch_api(name_id)
      stub_api_response(
        :get, ["product", name_id].join("/"), filename: "product", status: 200
      )
    end

    def stub_digicert_certificate_request_list_api
      stub_api_response(
        :get, "request", filename: "certificate_requests", status: 200
      )
    end

    def stub_digicert_certificate_request_fetch_api(request_id, json_file = nil)
      json_file ||= "certificate_request"

      stub_api_response(
        :get,
        ["request", request_id].join("/"),
        filename: json_file,
        status: 200,
      )
    end

    def stub_digicert_certificate_request_update_api(request_id, attributes)
      stub_api_response(
        :put,
        ["request", request_id, "status"].join("/"),
        data: attributes,
        filename: "empty",
        status: 204,
      )
    end

    def stub_digicert_order_create_api(certificate_type, attributes)
      stub_api_response(
        :post,
        ["order/certificate", certificate_type].join("/"),
        data: attributes,
        filename: "order_created",
        status: 201,
      )
    end

    def stub_digicert_order_with_immediate_issuance(cert_type, attributes)
      stub_api_response(
        :post,
        ["order/certificate", cert_type].join("/"),
        filename: "order_created_with_immediate_issuance",
        status: 201,
      )
    end

    def stub_digicert_order_fetch_api(order_id, file = "order")
      stub_api_response(
        :get, ["order/certificate", order_id].join("/"), filename: file
      )
    end

    def stub_digicert_order_list_api(params = {})
      stub_api_response(
        :get,
        path_with_query("order/certificate", params),
        filename: "orders",
        status: 200,
      )
    end

    def stub_digicert_certificate_order_fetch_api(order_id)
      stub_api_response(
        :get, ["order/certificate", order_id].join("/"), filename: "order"
      )
    end

    def stub_digicert_organization_list_api(params = {})
      stub_api_response(
        :get,
        path_with_query("organization", params),
        filename: "organizations",
        status: 200,
      )
    end

    def stub_digicert_organization_create_api(organization_attributes)
      stub_api_response(
        :post,
        "organization",
        data: organization_attributes,
        filename: "organization_created",
        status: 201,
      )
    end

    def stub_digicert_organization_fetch_api(id)
      stub_api_response(
        :get, ["organization", id].join("/"), filename: "organization"
      )
    end

    def stub_digicert_container_template_list_api(container_id)
      stub_api_response(
        :get,
        ["container", container_id, "template"].join("/"),
        filename: "container_templates",
        status: 200,
      )
    end

    def stub_digicert_container_template_fetch_api(template_id, container_id)
      stub_api_response(
        :get,
        ["container", container_id, "template", template_id].join("/"),
        filename: "container_template",
        status: 200,
      )
    end

    def stub_digicert_container_create_api(container_id:, **attributes)
      stub_api_response(
        :post,
        ["container", container_id, "children"].join("/"),
        data: attributes,
        filename: "container_created",
        status: 201,
      )
    end

    def stub_digicert_container_list_api
      stub_api_response(
        :get, "container", filename: "containers", status: 200
      )
    end

    def stub_digicert_container_fetch_api(container_id)
      stub_api_response(
        :get, ["container", container_id].join("/"), filename: "container"
      )
    end

    def stub_digicert_domain_create_api(attributes)
      stub_api_response(
        :post,
        "domain",
        data: attributes,
        filename: "domain_created",
        status: 201,
      )
    end

    def stub_digicert_domain_list_api(filters = {})
      stub_api_response(
        :get, path_with_query("domain", filters), filename: "domains"
      )
    end

    def stub_digicert_domain_fetch_api(domain_id, filters)
      stub_api_response(
        :get,
        path_with_query(["domain", domain_id].join("/"), filters),
        filename: "domain",
        status: 200,
      )
    end

    def stub_digicert_domain_activate_api(domain_id)
      stub_api_response(
        :put,
        ["domain", domain_id, "activate"].join("/"),
        filename: "empty",
        status: 204,
      )
    end

    def stub_digicert_domain_deactivate_api(domain_id)
      stub_api_response(
        :put,
        ["domain", domain_id, "deactivate"].join("/"),
        filename: "empty",
        status: 204,
      )
    end

    def stub_digicert_email_validations_api(order_id)
      stub_api_response(
        :get,
        ["order", "certificate", order_id, "email-validation"].join("/"),
        filename: "email_validations",
        status: 200,
      )
    end

    def stub_digicert_email_validations_validate_api(token:, email:)
      stub_api_response(
        :put,
        path_with_query("email-validation/#{token}", email: email),
        filename: "empty",
        status: 204,
      )
    end

    def stub_digicert_order_reissue_api(order_id, attributes)
      stub_api_response(
        :post,
        ["order", "certificate", order_id, "reissue"].join("/"),
        data: { certificate: attributes },
        filename: "order_reissued",
        status: 201,
      )
    end

    def stub_digicert_order_duplicate_api(order_id, attributes)
      stub_api_response(
        :post,
        ["order", "certificate", order_id, "duplicate"].join("/"),
        data: { certificate: attributes },
        filename: "order_duplicated",
        status: 201,
      )
    end

    def stub_digicert_order_duplications_api(order_id)
      stub_api_response(
        :get,
        ["order", "certificate", order_id, "duplicate"].join("/"),
        filename: "order_duplications",
        status: 200,
      )
    end

    def stub_digicert_order_cancellation_api(order_id, attributes)
      stub_api_response(
        :put,
        ["order", "certificate", order_id, "status"].join("/"),
        data: attributes,
        filename: "empty",
        status: 204,
      )
    end

    def stub_digicert_order_expiring_api(container_id)
      stub_api_response(
        :get,
        ["report", "order", container_id, "expiring"].join("/"),
        filename: "expiring_orders",
        status: 200,
      )
    end

    def stub_digicert_certificate_revoke_api(id, attributes)
      stub_api_response(
        :put,
        ["certificate", id, "revoke"].join("/"),
        data: attributes,
        filename: "certificate_revoked",
        status: 201,
      )
    end

    def stub_digicert_certificate_download_by_format(id, format, ext = "zip")
      stub_api_response_with_io(
        :get,
        ["certificate", id, "download", "format", format].join("/"),
        filename: ["certificate", ext].join("."),
        status: 200,
      )
    end

    def stub_digicert_certificate_download_by_platform(id, platform = nil)
      stub_api_response_with_io(
        :get,
        ["certificate", id, "download", "platform", platform].compact.join("/"),
        filename: "certificate.zip",
        status: 200,
      )
    end

    def stub_api_response(method, end_point, filename:, status: 200, data: nil)
      stub_request(method, digicert_api_end_point(end_point)).
        with(digicert_api_request_headers(data: data)).
        to_return(response_with(filename: filename, status: status))
    end

    def stub_api_response_with_io(method, end_point, filename:, status: 200)
      stub_request(method, digicert_api_end_point(end_point)).
        with(digicert_api_request_headers(data: nil)).
        to_return(response_with_file(file: filename, status: status))
    end

    private

    def digicert_api_end_point(end_point)
      ["https://www.digicert.com/services/v2", end_point].join("/")
    end

    def path_with_query(path, params)
      query_params = Digicert::Util.to_query(params)
      [path, query_params].join("?")
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

    def response_with_file(file:, status:)
      {
        status: status,
        body: File.new(File.expand_path("../../fixtures/#{file}", __FILE__)),
      }
    end

    def api_key_header
      {
        "Content-Type" => "application/json",
        "X-DC-DEVKEY" => Digicert.configuration.api_key,
      }
    end

    def digicert_fixture(filename)
      file_name = [filename, "json"].join(".")
      file_path = File.join(Digicert.root, "spec", "fixtures", file_name)

      File.read(File.expand_path(file_path, __FILE__))
    end
  end
end
