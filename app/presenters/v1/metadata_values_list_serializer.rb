module V1
  class MetadataValuesListSerializer < ActiveModel::Serializer

    attributes :id, :name, :description, :created_at, :created_by_id, :updated_at, :updated_by_id

    has_many :metadata_list_values, :serializer => V1::MetadataListValueSerializer, :embed => :objects

    def attributes
      hash = super
      hash[:links] = [
        { :rel => 'self', :href => metadata_values_list_url(id) }
      ]
      hash
    end

  end
end
