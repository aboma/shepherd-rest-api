module V1
  class MetadataTemplateFieldSettingSerializer < ActiveModel::Serializer 

    attributes :id, :required, :order, :created_at, :updated_at

    has_one :metadata_field, :embed => :ids

    def attributes
      hash = super
      hash[:links] = [
        { :rel => 'self', :href => metadata_template_field_setting_url(id) }
      ]
      hash
    end

  end
end
