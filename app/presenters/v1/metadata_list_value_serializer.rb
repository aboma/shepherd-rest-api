module V1
  class MetadataListValueSerializer < ActiveModel::Serializer

    attributes :id, :value, :description

    has_one :metadata_values_list, :serializer => V1::MetadataValuesList, :embed => :id
  end
end
