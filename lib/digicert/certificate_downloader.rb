require "digicert/base"

module Digicert
  class CertificateDownloader < Digicert::Base
    def fetch
      Digicert::Request.new(:get, certificate_download_path).run
    end

    def fetch_to_path(path:, extension: "zip")
      download_to_path(path: path, extension: extension)
    end

    def self.fetch(certificate_id, attributes = {})
      new(attributes.merge(resource_id: certificate_id)).fetch
    end

    def self.fetch_by_format(certificate_id, format:)
      fetch(certificate_id, format: format)
    end

    def self.fetch_by_platform(certificate_id, platform:)
      fetch(certificate_id, platform: platform)
    end

    def self.fetch_to_path(certificate_id, path:, ext: "zip", **attributes)
      new(attributes.merge(resource_id: certificate_id)).
        fetch_to_path(path: path, extension: ext)
    end

    private

    attr_reader :format, :platform

    def extract_local_attribute_ids
      @format = attributes.delete(:format)
      @platform = attributes.delete(:platform)
    end

    def resource_path
      ["certificate", resource_id, "download"].join("/")
    end

    def certificate_download_path
      download_path_by_format ||
        download_path_by_platfrom ||
        download_path_by_order_specified_platfrom
    end

    def download_to_path(path:, extension:)
      response = fetch

      if response.code.to_i == 200
        write_to_path(response.body, path: path, extension: extension)
      end
    end

    def download_path_by_format
      if format
        [resource_path, "format", format].join("/")
      end
    end

    def download_path_by_platfrom
      if platform
        [resource_path, "platform", platform].join("/")
      end
    end

    def download_path_by_order_specified_platfrom
      [resource_path, "platform"].join("/")
    end

    def write_to_path(content, path:, extension:)
      filename = ["certificate", extension].join(".")
      file_with_path = [path, filename].join("/")

      File.open(file_with_path, "w") do |file|
        file.write(content)
      end
    end
  end
end
