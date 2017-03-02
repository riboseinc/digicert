module Digicert
  module Findable
    # The `.find` interface is just an alternvatie to instantiate
    # a new object, and please remeber this does not perform any
    # actual API Request. Use this interface whenever you need to
    # instantite an object from an existing id and then perform
    # some operation throught the objec's instnace methods, like
    # `#active`, `#reissue` and etc
    #
    # If you need an actual API response then use the `.fetch`
    # API, that will perform an actual API Reqeust and will return
    # the response from the Digicer API.
    #
    # We are not going to implement this right away, but in long
    # run may be we cna add some sort to lazy evaluation on this
    # interface, but that's not for sure.
    #
    def find(resource_id)
      new(resource_id: resource_id)
    end
  end
end
