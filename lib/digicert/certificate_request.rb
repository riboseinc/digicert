require "digicert/base"
require "digicert/actions/update"

module Digicert
  class CertificateRequest < Digicert::Base
    include Digicert::Actions::Update

    private

    def resource_path
      "request"
    end

    def resource_update_path
      [resource_path, resource_id, "status"].join("/")
    end
  end
end
