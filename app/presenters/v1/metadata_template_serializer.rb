module V1
  class MetadataTemplateSerializer < ActiveModel::Serializer 

    attributes :id, :name, :description, :created_at, :updated_at

    has_many :metadata_template_field_settings, embed: :objects

    def attributes
      hash = super
      hash[:links] = {
        self: metadata_template_url(id) 
      }
      hash
    end

  end
end
