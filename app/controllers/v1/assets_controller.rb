module V1
  class AssetsController < V1::ApplicationController
    before_filter :find_portfolio, :only => [:index, :create]
    respond_to :json
    
    def index
      respond_to do |format|
        format.json do
          if @portfolio
            render :json => @portfolio.assets, :each_serializer => V1::AssetSerializer
          else
            render :json => {}, :status => :not_found
          end
        end      
      end
    end
    
    def create
      alt_params = params.merge(:created_by_id => current_user.id, :updated_by_id => current_user.id)
      asset = Asset.create(alt_params)
      #if (asset.valid? && @portfolio)
      #  relationship = asset.relate!(@portfolio)
      #end
      respond_to do |format|
        format.json do
          if asset.valid?
            render :json => asset, :serializer => V1::AssetSerializer
          else
            render :json => { :error => asset.errors }, :status => :unprocessable_entity
          end
        end
      end
    end
    
    def show 
      asset_id = params[:asset_id] || params[:id]
      asset = Asset.find_by_id(asset_id)
      respond_to do |format|
        format.json do
          if asset 
            render :json => asset, :serializer => V1::AssetSerializer
          else 
            render :json => {}, :status => :not_found
          end
        end
      end
    end
    
    private 
    
    def find_portfolio
      @portfolio = Portfolio.find_by_id(params[:portfolio_id])
    rescue ActiveRecord::RecordNotFound
      @error = "portfolio not found"
    end
  end
end