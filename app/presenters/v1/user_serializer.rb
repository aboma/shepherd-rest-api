module V1
  class UserSerializer < V1::VilioSerializer
    attributes :id, :email, :last_name, :first_name
    
  end
end