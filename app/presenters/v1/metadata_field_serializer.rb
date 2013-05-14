module V1
  class MetadataFieldSerializer < ActiveModel::Serializer 

    attributes :id, :name, :description, :type

  end
end
