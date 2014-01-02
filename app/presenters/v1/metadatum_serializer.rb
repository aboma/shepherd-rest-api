module V1
  class MetadatumSerializer < V1::ShepherdSerializer

    attributes :id, :metadatum_value

    has_one :asset, embed: :ids, include: false
    has_one :metadatum_field, embed: :ids, include: false

  end
end
