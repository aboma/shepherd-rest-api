class V1::AssetsController < V1::ApplicationController
  respond_to :json
  
  def create
    @all_params = params.merge(:created_by_id => current_user.id, :updated_by_id => current_user.id)
    @asset = Asset.create(@all_params)
    if (@asset.valid? && params[:portfolio_id])
      @relationship = @asset.relate!(params[:portfolio_id])
    end
    respond_to do |format|
      format.json do
        if @asset.valid?
          render :json => @asset, :serializer => V1::AssetSerializer
        else
          render :json => { :error => @asset.errors }, :status => :unprocessable_entity
        end
      end
    end
  end
end