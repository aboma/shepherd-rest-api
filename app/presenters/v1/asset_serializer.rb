class V1::AssetSerializer < ActiveModel::Serializer
  attributes :id, :name, :filename, :description
  
end