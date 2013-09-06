module V1
  class UserSerializer < V1::VilioSerializer
    attributes :id, :email, :last_name, :first_name, :created_at, :updated_at

    def attributes
      hash = super
      hash[:links] = [
        { :rel => 'self', :href => user_url(id) }
      ]
      hash
    end

  end
end
