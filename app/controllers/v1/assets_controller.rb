class V1::AssetsController < V1::ApplicationController
  respond_to :json
  
  def create
    @asset = Asset.create(params.merge(:created_by_id => current_user.id, :updated_by_id => current_user.id))
    respond_to do |format|
      format.json do
        render :json => @asset, :serializer => V1::AssetSerializer
      end
    end
  end
end