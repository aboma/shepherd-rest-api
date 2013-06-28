module V1
  class MetadataTemplateSerializer < ActiveModel::Serializer 

    attributes :name, :created_at, :updated_at

    has_many :metadata_template_field_settings, :embed => :ids

    def attributes
      hash = super
      hash[:links] = [
        { :rel => 'self', :href => metadata_template_url(id) }
      ]
      hash
    end

  end
end
