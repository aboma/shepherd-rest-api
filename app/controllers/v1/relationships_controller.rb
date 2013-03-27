module V1 
  class RelationshipsController < V1::ApplicationController
    include V1::Concerns::Relate
    include V1::Concerns::Auditable
    
    before_filter :allow_only_json_requests, :except => [:create]
    before_filter :find_portfolio, :only => [:index, :create]
    before_filter :find_asset, :only => [:index, :create]
    
    # Either return all relationships or return relationships
    # filtered by portfolio or asset
    def index
      relations = @portfolio.relationships if @portfolio
      relations = @asset.relationships if @asset
      relations = Relationship.find(:all) unless @portfolio || @asset
      respond_to do |format|
        format.json do
          if (@error)
            render :json => { :error => @error }, :status => 422
          else
            render :json => relations, :each_serializer => V1::RelationshipSerializer
          end
        end      
      end
    end
    
    # Create relationship between asset and portfolio; if asset 
    # details are posted too, create asset first, then create
    # relationship
    def create
      @error = 'no portfolio id specified' unless @portfolio
      unless (@error)
        relation = V1::Relationship.new
        @asset = V1::Asset.new unless @asset
        created = create_relation(relation, @asset, @portfolio)
        @error = (relation.errors.to_a + @asset.errors.to_a) if !created
      end
      respond_to do |format|
        format.json do
          if (@error)
            render :json => { :error => @error }, :status => 422
          else
            render :json => relation, :serializer => V1::RelationshipSerializer
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
    rescue
      @error = "portfolio with id #{params[:portfolio_id]} not found"
    end
    
    # Find asset requested by user, if one is requested, to filter
    # relationships by or to add to
    def find_asset
      return nil unless params[:asset_id]
      @asset = Asset.find_by_id(params[:asset_id])
    rescue
      @error = "asset with id #{params[:asset_id]} not found"
    end
    
    def create_relation(relation, asset, portfolio)
      V1::Relationship.transaction do  
        if asset.new_record?
          asset.attributes = add_audit_params(asset, params) 
          asset.save!         
        end
        relate_asset_and_portfolio!(relation, asset, portfolio)
      end
      return true
    rescue => e
      logger.error "error creating relationship: #{e}"
      return false  
    end
  end
end