module V1
  class ShepherdSerializer < ActiveModel::Serializer
    #sideload related data by default
    embed :ids, :include => true
  end
end