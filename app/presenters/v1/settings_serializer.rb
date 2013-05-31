module V1
  class SettingsSerializer < ActiveModel::Serializer

    attributes :field_types
    def field_types
      object.field_type
    end

  end
end
