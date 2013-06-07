module V1
  class MetadataFieldSerializer < ActiveModel::Serializer 

    attributes :id, :name, :description, :type, :created_at, :updated_at

    has_one :allowed_values_list, :embed => :ids

    def attributes
      hash = super
      hash[:links] = [
        { :rel => 'self', :href => metadata_field_url(id) }
      ]
      hash
    end

  end
end
