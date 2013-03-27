module V1::Concerns::Asset
  extend ActiveSupport::Concern
  include V1::Concerns::Auditable
  
  def update_asset(asset)
    set_attrs(asset)
    asset.save
  end
  
  def update_asset!(asset)
    set_attrs(asset)
    asset.save!    
  end
  
  private 
  
  def set_attrs(asset)
    raise ArgumentError, 'no asset fields provided' unless params[:asset]
    asset.attributes = add_audit_params(asset, params[:asset])
  end
end