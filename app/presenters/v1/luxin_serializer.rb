class V1::LuxinSerializer < ActiveModel::Serializer
  #sideload related data by default
  embed :ids, :include => true
end