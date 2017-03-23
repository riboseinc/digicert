module Digicert
  class DuplicateCertificateFinder
    def initialize(request_id:)
      @request_id = request_id
    end

    def find
      certificate_by_date_created
    end

    def self.find_by(request_id:)
      new(request_id: request_id).find
    end

    private

    attr_reader :request_id

    def certificate_by_date_created
      certificates_by_date_created.first
    end

    def certificates_by_date_created
      duplicate_certificates.select do |certificate|
        certificate.date_created == request_created_at
      end
    end

    def duplicate_certificates
      @duplicate_certificates ||=
        Digicert::DuplicateCertificate.all(order_id: request.order.id)
    end

    def request_created_at
      request.order.certificate.date_created
    end

    def request
      @request ||= Digicert::CertificateRequest.fetch(request_id)
    end
  end
end
