class V1::RelationshipSerializer < V1::LuxinSerializer
  #include Rails.application.routes.url_helpers
  
  attributes :id, :relationship_type, :asset_id, :portfolio_id, :created_at, :updated_at
   
  #has_one :asset, :key => :asset_id
end