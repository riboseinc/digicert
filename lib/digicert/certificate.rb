require "digicert/base"

module Digicert
  class Certificate < Digicert::Base
    extend Digicert::Findable

    def download(attributes = {})
      new_downloader(attributes).fetch
    end

    def revoke
      Digicert::Request.new(:put, revocation_path, attributes).parse
    end

    def self.revoke(certificate_id, attributes = {})
      new(attributes.merge(resource_id: certificate_id)).revoke
    end

    private

    def new_downloader(attributes)
      Digicert::CertificateDownloader.new(
        attributes.merge(resource_id: resource_id),
      )
    end

    def resource_path
      "certificate"
    end

    def revocation_path
      [resource_path, resource_id, "revoke"].join("/")
    end
  end
end
