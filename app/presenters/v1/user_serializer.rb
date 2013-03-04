module V1
  class UserSerializer < V1::LuxinSerializer
    attributes :id, :email, :last_name, :first_name
    
  end
end