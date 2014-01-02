module V1
  class SessionSerializer < V1::ShepherdSerializer
    attributes :id, :email

    # this is a singleton that shows only the current user session,
    # so deafult the session id to 1
    def id
      1
    end

    def attributes
      hash = super
      hash[:settings] = { id: 1, field_types: Settings.field_types.join(',') }
      hash
    end
  end
end
