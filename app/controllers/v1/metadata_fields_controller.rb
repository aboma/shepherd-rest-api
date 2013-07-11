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
          @field = V1::MetadataField.new
          if update_field(@field)
            response.headers['Location'] = metadata_field_path(@field)
            render :json => @field, :serializer => V1::MetadataFieldSerializer
          else 
            status = conflict? ? :conflict : :unprocessable_entity
            render :json => { :errors => @field.errors }, :status => status
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
          if update_field(@field)
            @field.reload
            render :json => @field, :serializer => V1::MetadataFieldSerializer
          else 
            status = conflict? ? :conflict : :unprocessable_entity
            render :json => { :errors => @field.errors }, :status => status 
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

    def conflict?
       return @field.errors[:name] && 
              @field.errors[:name].include?("has already been taken")
    end
  end
end
