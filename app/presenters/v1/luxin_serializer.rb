module V1
  class LuxinSerializer < ActiveModel::Serializer
    #sideload related data by default
    embed :ids, :include => true
  end
end