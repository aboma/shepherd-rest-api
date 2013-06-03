module V1
  class SettingsSerializer < ActiveModel::Serializer

    attributes :field_types
    def field_types
      object.field_types.join(',')
    end

  end
end
