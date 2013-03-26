module V1::Concerns::Relate
  extend ActiveSupport::Concern
  
  # create a relationship between a portfolio 
  # and an asset
  def relate_asset_and_portfolio(asset, portfolio)
    attrs = { :asset_id => self.id, :portfolio_id => portfolio.id, :relationship_type => 'Asset' }
    relation = V1::Relationship.new
    relation.attributes = attrs
    relation.save!
    return relation
  rescue
    return nil
  end
  
end