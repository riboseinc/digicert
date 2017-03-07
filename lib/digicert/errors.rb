require "digicert/errors/request_error"
require "digicert/errors/forbidden"
require "digicert/errors/server_error"
require "digicert/errors/unauthorized"

module Digicert
  module Errors
    def self.server_errors
      [
        OpenSSL::SSL::SSLError,
        Errno::ETIMEDOUT,
        Errno::EHOSTUNREACH,
        Errno::ENETUNREACH,
        Errno::ECONNRESET,
        Net::OpenTimeout,
        SocketError,
        Net::HTTPServerError
      ]
    end

    def self.error_klass_for(response)
      case response
      when *server_errors then Errors::ServerError
      when Net::HTTPUnauthorized then Errors::Unauthorized
      when Net::HTTPForbidden then Errors::Forbidden
      else Errors::RequestError
      end
    end
  end
end
