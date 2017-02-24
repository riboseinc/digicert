require "digicert/base"

module Digicert
  class CertificateDownloader < Digicert::Base
    def initialize(attributes = {})
      @platform = attributes.delete(:platform)
      super
    end

    def fetch
      Digicert::Request.new(:get, certificate_download_path).run
    end

    def self.fetch_by_platform(certificate_id, platform:)
      new(resource_id: certificate_id, platform: platform).fetch
    end

    private

    attr_reader :platform

    def resource_path
      ["certificate", resource_id, "download"].join("/")
    end

    def certificate_download_path
      download_path_by_platfrom || download_path_by_order_specified_platfrom
    end

    def download_path_by_platfrom
      if platform
        [resource_path, "platform", platform].join("/")
      end
    end

    def download_path_by_order_specified_platfrom
      [resource_path, "platform"].join("/")
    end
  end
end
