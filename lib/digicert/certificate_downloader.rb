require "digicert/base"

module Digicert
  class CertificateDownloader < Digicert::Base
    def fetch
      Digicert::Request.new(:get, download_by_platfrom_path).run
    end

    private

    def download_by_platfrom_path
      [resource_path, "platform"].join("/")
    end

    def resource_path
      ["certificate", resource_id, "download"].join("/")
    end
  end
end
