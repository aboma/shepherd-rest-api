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
      relations = V1::Relationship.find(:all) unless @portfolio || @asset
      respond_to do |format|
        format.json do
          render :json => relations, :each_serializer => V1::RelationshipSerializer
        end      
      end
    end
    
    # Create relationship between asset and portfolio; if asset 
    # details are posted too, create asset first, then create
    # relationship
    def create
      @error = 'no portfolio id specified' if (!@portfolio && !@error)
      @error = 'relationship already exists' if find_relation(params[:relationship])
      unless (@error)
        relation = V1::Relationship.new
        @asset = V1::Asset.new unless @asset
        created = create_relation(relation, @asset, @portfolio)
        @error = (relation.errors.to_a + @asset.errors.to_a) if !created
      end
      respond_to do |format|
        format.json do
          if @error
            render :json => { :error => @error }, :status => 422
          else
            response.headers['Location'] = relationships_path(relation)
            render :json => relation, :serializer => V1::RelationshipSerializer
          end
        end        
      end
    end
    
    def show
      relation = find_relation(params)
      respond_to do |format|
        format.json do
          if relation
            render :json => relation, :serializer => V1::RelationshipSerializer
          else
            render :json => { :error => "relationship not found" }, :status => 404
          end
        end
      end
    end
    
    
    
    private 
    
    # Find portfolio requested by user, if one is requested,
    # to filter relationships by or to add to
    def find_portfolio
      id = portfolio_id
      return nil unless id
      @portfolio = V1::Portfolio.find(id)
    rescue
      @error = "portfolio with id #{id} not found"
    end
    
    # Find asset requested by user, if one is requested, to filter
    # relationships by or to add to
    def find_asset
      id = asset_id
      return nil unless id
      @asset = V1::Asset.find(id)
    rescue
      @error = "asset with id #{id} not found"
    end
    
    def relation_exists?
      args = { :portfolio_id => portfolio_id, :asset_id => asset_id }
      V1::Relationship.exists?(args)
    end
    
    def find_relation(args)
      return V1::Relationship.find(args[:id]) if args[:id]
      return V1::Relationship.where(:portfolio_id => portfolio_id).where(:asset_id => asset_id).first \
        unless args[:id]
    rescue 
      return nil
    end
    
    def portfolio_id
      params[:portfolio_id] || params[:relationship][:portfolio_id]
    end
    
    def asset_id
      params[:asset_id] || params[:relationship][:asset_id]
    end
    
    # create relationship; if asset not provided, try to create
    # one from params and then create relationship to portfolio
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