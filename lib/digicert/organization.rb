# Confidential and proprietary trade secret material of Ribose, Inc.
# (c) 2017 Ribose, Inc. as unpublished work.
#
#
require "digicert/base"

module Digicert
  class Organization < Digicert::Base
    private

    def resource_path
      "organization"
    end
  end
end
