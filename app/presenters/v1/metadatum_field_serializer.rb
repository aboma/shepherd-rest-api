module V1
  class MetadatumFieldSerializer < V1::ShepherdSerializer 

    attributes :id, :name, :description, :type, :created_at, :updated_at

    has_one :allowed_values_list, embed: :ids, include: false

    def attributes
      hash = super
      hash[:links] = { 
          self: metadatum_field_url(id)
      }
      hash
    end

  end
end
