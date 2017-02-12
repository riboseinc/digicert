# Confidential and proprietary trade secret material of Ribose, Inc.
# (c) 2017 Ribose, Inc. as unpublished work.
#
#

module Digicert::Certificate
  class Private < Ssl

    REQUEST_ATTRS = {
      certificate: {
        common_name: String,
        csr: String,
        emails: [ String ],
        signature_hash: %w(sha1)
      },
      organization: {
        id: Integer
      },
      validity_years: Integer,
      comments: String
    }

    def download(format)
      open(
        Endpoint.certificate_download,
        "X-DC-DEVKEY" => key,
        "Content-Type" => "*/*",
      ) {|f|
        f.each_line {|line| p line}
      }

    end

    # https://www.digicert.com/services/v2/documentation/certificate/download-client-certificate
    # https://www.digicert.com/services/v2/certificate/{certificate_id}/download/format/p7b
    #
    def download_client_certificate
      Endpoint.download_client_certificate

    end
  end

end


