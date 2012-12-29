class V1::AssetsController < V1::ApplicationController
  before_filter :find_portfolio
  respond_to :json
  
  def index
    respond_to do |format|
      format.json do
        render :json => @portfolio.assets, :each_serializer => V1::AssetSerializer
      end      
    end
  end
  
  def create
    @all_params = params.merge(:created_by_id => current_user.id, :updated_by_id => current_user.id)
    @asset = Asset.create(@all_params)
    if (@asset.valid? && @portfolio)
      @relationship = @asset.relate!(@portfolio)
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
  
  def show 
    
  end
  
  private 
  
  def find_portfolio
    @portfolio = Portfolio.find(params[:portfolio_id])
  end

end