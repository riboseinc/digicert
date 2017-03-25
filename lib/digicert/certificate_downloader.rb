require "digicert/base"

module Digicert
  class CertificateDownloader < Digicert::Base
    def fetch
      request_klass.new(:get, certificate_download_path).run
    end

    def fetch_to_path(path:, extension: "zip")
      download_to_path(path: path, extension: extension)
    end

    def fetch_content
      extract_certificate_content
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

    def self.fetch_content(certificate_id)
      new(resource_id: certificate_id, format: "pem_all").fetch_content
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
        download_path_by_platform ||
        download_path_by_order_specified_platform
    end

    def download_to_path(path:, extension:)
      response = fetch

      if response.code.to_i == 200
        write_to_path(response.body, path: path, extension: extension)
      end
    end

    def extract_certificate_content
      convert_response_to_hash(fetch.body)
    end

    def download_path_by_format
      if format
        [resource_path, "format", format].join("/")
      end
    end

    def download_path_by_platform
      if platform
        [resource_path, "platform", platform].join("/")
      end
    end

    def download_path_by_order_specified_platform
      [resource_path, "platform"].join("/")
    end

    def convert_response_to_hash(content)
      contents = split_pem_certificates(content)

      Hash.new.tap do |content_hash|
        content_hash[:certificate] = contents[0]
        content_hash[:intermediate_certificate] = contents[1]
        content_hash[:root_certificate] = contents[2]
      end
    end

    # Spliting certificate content
    #
    # Digicert returns all of the certificates including `root` one when
    # we specify `pem_all` as format. The format it returns the content
    # has a pattern, which is it will have all of the three certificates.
    # The sequance for the certificates are `certificate`, `intermediate`
    # and `root` and each of them are separated by `END CERTIFICATE-----`
    #
    # This method will split those using the specified identifier and it
    # will return an array in the same sequance.
    #
    def split_pem_certificates(content)
      content.split(/(?<=END CERTIFICATE-----)\r?\n/)
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
