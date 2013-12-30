module V1
  class SessionSerializer < V1::ShepherdSerializer
    attributes :id, :email

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
