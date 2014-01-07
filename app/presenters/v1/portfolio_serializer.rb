module V1
  class PortfolioSerializer < V1::ShepherdSerializer
    include Rails.application.routes.url_helpers

    attributes :id, :name, :description, :created_at, :updated_at

    has_one :metadata_template, embed: :ids, include: false

    def attributes
      hash = super
      hash[:links] = { 
          self: portfolio_url(id),
          relationships: relationships_url({ portfolio_id: id, format: nil }) 
      }
      hash
    end
  end
end
