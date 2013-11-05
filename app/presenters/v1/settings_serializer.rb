module V1
  class SettingsSerializer < V1::ShepherdSerializer

    attributes :field_types, :demo_version

    def field_types
      object.field_types.join(',')
    end

    def demo_version
      object.demo_version
    end
  end
end
