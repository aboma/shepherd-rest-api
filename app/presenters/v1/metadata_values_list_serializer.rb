module V1
  class MetadataValuesListSerializer < ActiveModel::Serializer

    attributes :id, :name, :description, :created_at, :created_by_id, :updated_at, :updated_by_id

    def attributes
      hash = super
      hash[:links] = [
        { :rel => 'self', :href => metadata_values_list_url(id) }
      ]
      hash
    end

  end
end
