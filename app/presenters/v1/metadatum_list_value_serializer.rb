module V1
  class MetadatumListValueSerializer < ActiveModel::Serializer

    attributes :id, :value, :description

    has_one :metadatum_values_list, :serializer => V1::MetadatumValuesList, :embed => :id
  end
end
