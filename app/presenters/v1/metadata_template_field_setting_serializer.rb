module V1
  class MetadataTemplateFieldSettingSerializer < ActiveModel::Serializer 

    attributes :id, :required, :order, :created_at, :updated_at

    has_one :metadatum_field, embed: :ids

    def attributes
      hash = super
      hash[:links] = {
        :self => metadata_template_field_setting_url(id) 
      }
      hash
    end

  end
end
