module V1
  class MetadatumSerializer < V1::VilioSerializer

    attributes :id, :value

    has_one :asset, :embed => :id
    has_one :field, :embed => :id

  end
end
