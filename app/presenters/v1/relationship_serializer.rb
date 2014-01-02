module V1
  class RelationshipSerializer < V1::ShepherdSerializer
    #include Rails.application.routes.url_helpers

    attributes :id, :created_at, :updated_at

    # include the asset definition in the relationship
    has_one :asset, serializer: V1::AssetSerializer, embed: :objects
    has_one :portfolio, embed: :ids, include: false
  end
end
