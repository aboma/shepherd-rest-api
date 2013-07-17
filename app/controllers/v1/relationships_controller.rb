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
      @error = { :id => 'no portfolio id specified' } if (!@portfolio && !@error)
      @error = { :id => 'relationship already exists' } if relation_exists?
      unless (@error)
        relation = V1::Relationship.new
        @asset = V1::Asset.new unless @asset
        created = create_relation(relation, @asset, @portfolio)
        @error = (relation.errors.to_a + @asset.errors.to_a) if !created
      end
      respond_to do |format|
        format.json do
          if @error
            render :json => { :errors => @error }, :status => 422
          else
            response.headers['Location'] = relationships_path(relation)
            render :json => relation, :serializer => V1::RelationshipSerializer
          end
        end        
      end
    end

    def show
      relation = find_relation
      respond_to do |format|
        format.json do
          if relation
            render :json => relation, :serializer => V1::RelationshipSerializer
          else
            render :json => { :errors => { :id => "relationship not found" } }, :status => 404
          end
        end
      end
    end

    # changes to relationships are not allowed: either they exist or they do not
    def update
      respond_to do |format|
        format.json do
          render :json => { :errors => { :id => "changes to relationships not allowed" } }, :status => 422
        end
      end
    end

    def destroy
      relation = find_relation
      respond_to do |format|
        format.json do
          if relation
            relation.destroy
            render :json => nil, :status => :ok 
          else
            render :json => { :errors => { :id => "relationship not found" } }, :status => 404
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
      @error = { :id => "portfolio with id #{id} not found" }
    end

    # Find asset requested by user, if one is requested, to filter
    # relationships by or to add to
    def find_asset
      id = asset_id
      return nil unless id
      @asset = V1::Asset.find(id)
    rescue
      @error = { :id => "asset with id #{id} not found" }
    end

    def find_relation
      id = relation_id
      return V1::Relationship.find(id) if id
      return V1::Relationship.where(:portfolio_id => portfolio_id).where(:asset_id => asset_id).first \
        unless id
    rescue 
      return nil
    end   

    def relation_exists?
      id = relation_id
      args = { :id => id } if id
      args = { :portfolio_id => portfolio_id, :asset_id => asset_id } if (portfolio_id && asset_id)
      return V1::Relationship.exists?(args) if args
      return nil unless args
    end

    def relation_id
      return params[:relationship][:id] if params[:relationship] && params[:relationship][:id]
      return params[:id]
    end

    def portfolio_id
      return params[:relationship][:portfolio_id] if params[:relationship] && params[:relationship][:portfolio_id]
      return params[:portfolio_id]
    end

    def asset_id
      return params[:relationship][:asset_id] if params[:relationship] && params[:relationship][:asset_id]
      return params[:asset_id]
    end

    # create relationship; if asset not provided, try to create
    # one from params and then create relationship to portfolio
    def create_relation(relation, asset, portfolio)
      return false unless asset && portfolio 
      V1::Relationship.transaction do  
        if asset.new_record?
          asset.attributes = params
          #asset.attributes[:file] = Base64.decode64(params[:asset][:file]).force_encoding('UTF-8') 
          add_audit_params(asset) 
          asset.save!         
        end
        relate_asset_and_portfolio!(relation, asset, portfolio)
      end
      return true
    rescue => e
      logger.error "error creating relationship: #{e}"
      return false  
    end


    def decode_file(base64_param)
      tempfile = Tempfile.new("fileupload")
      tempfile.binmode
      #get the file and decode it with base64 then write it to the tempfile
      tempfile.write(Base64.decode64(picture_path_params["file"]))

      #create a new uploaded file
      #uploaded_file = ActionDispatch::Http::UploadedFile.new(:tempfile => tempfile) 

      #replace picture_path with the new uploaded file
      #params[:picture][:picture_path] =  uploaded_file
    end
  end
end
