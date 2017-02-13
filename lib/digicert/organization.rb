# Confidential and proprietary trade secret material of Ribose, Inc.
# (c) 2017 Ribose, Inc. as unpublished work.
#
#

module Digicert
  class Organization

    GENERATED_ATTRS = %i(
      id
      name
      display_name
      is_active
      city
      state
      country
    )
    attr_accessor *GENERATED_ATTRS

    def initialize options={}
      options.each_pair do |k, v|
        send("#{k}=", v)
      end
    end
  end
end

