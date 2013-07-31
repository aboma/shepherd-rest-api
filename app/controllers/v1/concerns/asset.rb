module V1::Concerns::Asset
  extend ActiveSupport::Concern
  include V1::Concerns::Auditable

  def update_asset(asset)
    update_asset!(asset)
    return true
  rescue
    return false
  end

  def update_asset!(asset)
    metadata_params = params[:asset].delete(:metadata)
    V1::Asset.transaction(:requires_new => true) do  
      set_attrs(asset)
      update_metadata(asset, metadata_params) if metadata_params
      asset.save!
    end
  end

  private 

  def set_attrs(asset)
    raise ArgumentError, 'no asset fields provided' unless params[:asset]
    asset.attributes = params[:asset]
    add_audit_params(asset)
  end

  def update_metadata(asset, metadata_params)
    specified_metadata = []
    metadata_params.each do |m_param|
      if m_param[:id]
        metadatum_value = asset.metadata.find(m_param[:id])
        metadatum_value.assign_attributes(m_param)
      else
        metadatum_value = asset.metadata.build(m_param)
      end
      add_audit_params(metadatum_value)
      specified_metadata << metadatum_value
    end
    asset.metadata.each do |existing_metadatum|
      existing_metadatum.destroy unless specified_metadata.include?(existing_metadatum)
    end
  end
end
