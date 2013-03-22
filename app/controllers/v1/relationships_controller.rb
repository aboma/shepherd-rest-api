module V1 
  class RelationshipsController < V1::ApplicationController
    before_filter :find_portfolio, :only => [:index, :create]
    before_filter :find_asset, :only => [:index, :create]
    
    # Either return all relationships or return relationships
    # filtered by portfolio or asset
    def index
      @relations = @portfolio.relationships if @portfolio
      @relations = @asset.relationships if @asset
      @relations = Relationship.find(:all) unless @portfolio || @asset
      respond_to do |format|
        format.json do
          if (@error)
            render :error => @error, :serializer => V1::RelationshipSerializer
          else
            render :json => @relations, :each_serializer => V1::RelationshipSerializer
          end
        end      
      end
    end
    
    # Create relationship between asset and portfolio; if asset 
    # details are posted too, create asset first, then create
    # relationship
    def create
      @error = 'no portfolio id specified' unless @portfolio
      unless @error
        ## attempt to create asset before adding relationship      
        unless @asset
          logger.info "creating asset"
          alt_params = params.merge(:created_by_id => current_user.id, :updated_by_id => current_user.id)
          @asset = V1::Asset.create(alt_params)
          #TODO handle asset creation error
        end
        if (@asset.valid?)
          logger.info "creating relationship"
          relationship = @asset.relate!(@portfolio)
        end
      end
      respond_to do |format|
        format.json do
          if (@error)
            render :error => @error, :serializer => V1::RelationshipSerializer
          else
            render :json => relationship, :serializer => V1::RelationshipSerializer
          end
        end        
      end
    end
    
    private 
    
    # Find portfolio requested by user, if one is requested,
    # to filter relationships by or to add to
    def find_portfolio
      return nil unless params[:portfolio_id]
      @portfolio = Portfolio.find_by_id(params[:portfolio_id])
    rescue ActiveRecord::RecordNotFound
      @error = "portfolio with id #{params[:portfolio_id]} not found"
    end
    
    # Find asset requested by user, if one is requested, to filter
    # relationships by or to add to
    def find_asset
      return nil unless params[:asset_id]
      @asset = Asset.find_by_id(params[:asset_id])
    rescue ActiveRecord::RecordNotFound
      @error = "asset with id #{params[:asset_id]} not found"
    end
  end
end