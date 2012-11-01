class V1::AssetSerializer < ActiveModel::Serializer
  attributes :id, :name, :file, :description, :portfolios
  
end