module V1
  class VilioSerializer < ActiveModel::Serializer
    #sideload related data by default
    embed :ids, :include => true
  end
end