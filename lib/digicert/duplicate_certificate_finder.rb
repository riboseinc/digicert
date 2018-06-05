module Digicert
  class DuplicateCertificateFinder
    def initialize(request_id:)
      @request_id = request_id
    end

    def find
      certificate_by_date_created || raise(
        Digicert::Errors::RequestError.new(
          request: "The request is still pending, needs an approval first!",
        ),
      )
    end

    def self.find_by(request_id:)
      new(request_id: request_id).find
    end

    private

    attr_reader :request_id

    def certificate_by_date_created
      if request.status == "approved"
        certificates_by_date_created.first
      end
    end

    def certificates_by_date_created
      (duplicate_certificates || []).select do |certificate|
        compare_date(certificate.date_created, request_created_at) < 5
      end
    end

    def duplicate_certificates
      @duplicate_certificates ||=
        Digicert::DuplicateCertificate.all(order_id: request.order.id)
    end

    def request_created_at
      request.order.certificate.date_created
    end

    def compare_date(from_date, to_date)
      from_time = DateTime.parse(from_date).to_time
      to_time = DateTime.parse(to_date).to_time

      from_time.to_i - to_time.to_i
    end

    def request
      @request ||= Digicert::CertificateRequest.fetch(request_id)
    end
  end
end
