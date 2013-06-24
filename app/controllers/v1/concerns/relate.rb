module V1::Concerns::Relate
  extend ActiveSupport::Concern
  include V1::Concerns::Auditable

  # create a relationship between a portfolio 
  # and an asset
  def relate_asset_and_portfolio(relation, asset, portfolio)
    relation.attributes = { :asset_id => asset.id, :portfolio_id => portfolio.id, :relationship_type => 'Asset' }
    add_audit_params(relation)
    relation.save
  end

  def relate_asset_and_portfolio!(relation, asset, portfolio)
    relation.attributes = { :asset_id => asset.id, :portfolio_id => portfolio.id, :relationship_type => 'Asset' }
    add_audit_params(relation)
    relation.save!
  end  

  def unrelate_asset_and_portfolio(relation)
    relation.destroy!
  end

end
