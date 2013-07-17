module V1
  class RelationshipSerializer < V1::VilioSerializer
    #include Rails.application.routes.url_helpers

    attributes :id, :relationship_type, :created_at, :updated_at

    # include the asset definition in the relationship
    has_one :asset, :key => :asset, :serializer => V1::AssetSerializer, :embed => :objects
    has_one :portfolio, :embed => :ids, :include => false
  end
end
