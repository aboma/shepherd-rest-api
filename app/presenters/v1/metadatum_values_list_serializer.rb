module V1
  class MetadatumValuesListSerializer < V1::ShepherdSerializer

    attributes :id, :name, :description, :created_at, :created_by_id, :updated_at, :updated_by_id

    has_many :metadatum_list_values, serializer: V1::MetadatumListValueSerializer, embed: :objects

    def attributes
      hash = super
      hash[:links] = {
        self: metadatum_values_list_url(id)
      }
      hash
    end

  end
end
