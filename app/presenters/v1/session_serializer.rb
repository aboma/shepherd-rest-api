module V1
  class SessionSerializer < V1::ShepherdSerializer
    attributes :email

    def attributes
      hash = super
      hash[:settings] = { :field_types => Settings.field_types.join(',') }
      hash
    end
  end
end
