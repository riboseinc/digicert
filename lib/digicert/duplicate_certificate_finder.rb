module Digicert
  class DuplicateCertificateFinder
    def initialize(reqeust_id:)
      @reqeust_id = reqeust_id
    end

    def find
      certificate_by_date_created
    end

    def self.find_by(reqeust_id:)
      new(reqeust_id: reqeust_id).find
    end

    private

    attr_reader :reqeust_id

    def certificate_by_date_created
      certificates_by_date_created.first
    end

    def certificates_by_date_created
      duplicate_certificates.select do |certificate|
        certificate.date_created == reqeust_created_at
      end
    end

    def duplicate_certificates
      @duplicate_certificates ||=
        Digicert::DuplicateCertificate.all(order_id: reqeust.order.id)
    end

    def reqeust_created_at
      reqeust.order.certificate.date_created
    end

    def reqeust
      @reqeust ||= Digicert::CertificateRequest.fetch(reqeust_id)
    end
  end
end
