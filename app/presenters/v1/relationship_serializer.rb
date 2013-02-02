class V1::RelationshipSerializer < ActiveModel::Serializer
  #include Rails.application.routes.url_helpers
  
  attributes :id, :relationship_type, :asset_id, :portfolio_id, :created_at, :updated_at
   
end