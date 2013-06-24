module V1
  class MetadataFieldsController < V1::ApplicationController
    include V1::Concerns::Auditable
    before_filter :allow_only_json_requests
    before_filter :find_field, :only => [:show, :update]

    def index
      fields = V1::MetadataField.all
      respond_to do |format|
        format.json do
          render :json => fields, :root => "metadata_fields", :each_serializer => V1::MetadataFieldSerializer
        end
      end
    end

    def show
      respond_to do |format|
        format.json do
          if @field
            render :json => @field, :root => "metadata_field", :serializer => V1::MetadataFieldSerializer
          else 
            render :json => {}, :status => 404
          end
        end
      end
    end

    def create
      respond_to do |format|
        format.json do
          if exists?
            render :json => { :errors => { :name => "field name already exists" } }, :status => :conflict
          else
            field = V1::MetadataField.new
            if update_field(field)
              response.headers['Location'] = metadata_field_path(field)
              render :json => field, :root => "metadata_field", :serializer => V1::MetadataFieldSerializer
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
            render :json => {}, :status => 404
            return
          end
          if update_field(@field)
            @field.reload
            render :json => @field, :root => "metadata_field", :serializer => V1::MetadataFieldSerializer
          else 
            render :json => { :errors => field.errors }, :status => :unprocessable_entity 
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

    def exists?
      name = params[:metadata_field][:name]
      return false unless name
      result = V1::MetadataField.find_by_name(name)
      return result.nil? == false
    end

  end
end
