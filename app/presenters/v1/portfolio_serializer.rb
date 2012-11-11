class V1::PortfolioSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  
  attributes :id, :name, :description, :created_at, :updated_at
  has_many :relationships
   
  def attributes
    hash = super
    hash[:links] = [
      { :rel => 'self', :href => portfolio_path(portfolio) }
    ]
    hash
  end
end