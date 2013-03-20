module V1
  class RelationshipSerializer < ActiveModel::Serializer
    #include Rails.application.routes.url_helpers
    
    attributes :id, :relationship_type, :portfolio_id, :created_at, :updated_at #, :asset_id
    
    # include the asset definition in the relationship
    has_one :asset, :key => :asset, :serializer => V1::AssetSerializer, :embed => :objects
    
  end
end