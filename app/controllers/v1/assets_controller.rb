module V1
  class AssetsController < V1::ApplicationController
    include V1::Concerns::Asset

    before_filter :allow_only_json_requests
    before_filter :find_asset, :only => [:show, :update]
    before_filter :find_portfolio, :only => [:index, :create]

    def index
      @assets = @portfolio.assets if @portfolio
      @assets ||= Asset.all
      respond_to do |format|
        format.json do
          if @assets
            render :json => @assets, :each_serializer => V1::AssetSerializer
          else
            render :json => {}, :status => :not_found
          end
        end      
      end
    end

    def create
      @asset = V1::Asset.new
      respond_to do |format|
        format.json do
          if update_asset(@asset)
            response.headers['Location'] = assets_path(@asset)
            render :json => @asset, :serializer => V1::AssetSerializer
          else
            status = conflict? ? :conflict : :unprocessable_entity
            render :json => { :errors => @asset.errors }, :status => status
          end
        end
      end
    end

    def show 
      respond_to do |format|
        format.json do
          if @asset
            render :json => @asset, :serializer => V1::AssetSerializer
          else 
            render :json => {}, :status => :not_found
          end
        end
      end
    end

    def update
      respond_to do |format|
        format.json do
          unless @asset
            render :json => nil, :status => :not_found
            return
          end
          if update_asset(@asset)
            render :json => @asset, :serializer => V1::AssetSerializer
          else
            status = conflict? ? :conflict : :unprocessable_entity
            render :json => { :errors => @asset.errors }, :status => status
          end
        end
      end
    end

    private 

    def find_portfolio
      @portfolio = Portfolio.find(params[:portfolio_id])
    rescue ActiveRecord::RecordNotFound
      @error = { :portfolio => "portfolio not found" }
    end

    def find_asset
      asset_id = params[:asset_id] || params[:id]
      @asset = V1::Asset.find(asset_id)
    rescue ActiveRecord::RecordNotFound
      @error = { :asset => "asset not found" }
    end

    def conflict?
       return @asset.errors[:name] && 
              @asset.errors[:name].include?("has already been taken")
    end

  end
end
