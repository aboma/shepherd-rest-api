class V1::UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :last_name, :first_name
  
end