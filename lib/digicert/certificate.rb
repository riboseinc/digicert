require "digicert/base"

module Digicert
  class Certificate < Digicert::Base
    extend Digicert::Findable

    def download(attributes = {})
      certificate_downloader.fetch(resource_id, attributes)
    end

    def revoke
      Digicert::Request.new(:put, revocation_path, attributes).parse
    end

    def self.revoke(certificate_id, attributes = {})
      new(attributes.merge(resource_id: certificate_id)).revoke
    end

    def download_to_path(path:, ext: "zip", **attributes)
      certificate_downloader.fetch_to_path(
        resource_id, attributes.merge(path: path, ext: ext),
      )
    end

    private

    def resource_path
      "certificate"
    end

    def revocation_path
      [resource_path, resource_id, "revoke"].join("/")
    end

    def certificate_downloader
      Digicert::CertificateDownloader
    end
  end
end
