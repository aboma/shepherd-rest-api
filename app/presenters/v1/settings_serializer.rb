module V1
  class SettingsSerializer < V1::ShepherdSerializer

    attributes :field_types
    def field_types
      object.field_types.join(',')
    end

  end
end
