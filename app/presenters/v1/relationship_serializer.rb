module V1
  class RelationshipSerializer < ActiveModel::Serializer
    #include Rails.application.routes.url_helpers
    
    attributes :id, :relationship_type, :asset_id, :portfolio_id, :created_at, :updated_at
    
    # include the asset definition in the relationship
    has_one :asset, :key => :asset, :serializer => V1::AssetSerializer
    
  end
end