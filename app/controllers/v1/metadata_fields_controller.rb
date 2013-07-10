module V1
  class MetadataFieldsController < V1::ApplicationController
    include V1::Concerns::Auditable
    before_filter :allow_only_json_requests
    before_filter :find_field, :only => [:show, :update, :destroy]

    def index
      fields = V1::MetadataField.all
      respond_to do |format|
        format.json do
          render :json => fields, :each_serializer => V1::MetadataFieldSerializer
        end
      end
    end

    def show
      respond_to do |format|
        format.json do
          if @field
            render :json => @field, :serializer => V1::MetadataFieldSerializer
          else 
            render :json => {}, :status => 404
          end
        end
      end
    end

    def create
      respond_to do |format|
        format.json do
          if name_exists?
            render :json => { :errors => { :name => "field name already exists" } }, :status => :conflict
          else
            field = V1::MetadataField.new
            if update_field(field)
              response.headers['Location'] = metadata_field_path(field)
              render :json => field, :serializer => V1::MetadataFieldSerializer
            else 
              render :json => { :errors => field.errors }, :status => :unprocessable_entity
            end
          end
        end
      end
    end

    def update
      respond_to do |format|
        format.json do
          unless @field 
            render :json => {}, :status => :not_found
            return
          end
          if name_exists?
            render :json => { :errors => { :name => "field name already exists" } }, :status => :conflict
            return
          end
          if update_field(@field)
            @field.reload
            render :json => @field, :serializer => V1::MetadataFieldSerializer
          else 
            render :json => { :errors => @field.errors }, :status => :unprocessable_entity 
          end
        end
      end
    end

    def destroy
      respond_to do |format|
        format.json do
          render :json => nil, :status => :not_found unless @field
          if @field
            begin
              @field.destroy
              if @field.destroyed?
                render :json => nil, :status => :ok
              else
                render :json => { :error => @field.errors }, :status => :unprocessable_entity
              end
            rescue 
              render :json => { :error => @field.errors }, :status => :unprocessable_entity
            end
          end
        end
      end
    end

  private 

    def find_field
      @field = MetadataField.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @error = "field not found"
    end

    def update_field(field)
      field.attributes = params[:metadata_field]
      add_audit_params(field)
      field.save
    end

    # determine if field name is already used
    def name_exists?
      name = params[:metadata_field][:name]
      return false unless name
      id = @field ? @field.id : 0
      result = V1::MetadataField.where('lower(name) = ?', name.downcase).where("id != ?", id)
      return result.any?() 
    end

  end
end
