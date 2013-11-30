module V1
  class MetadatumFieldsController < V1::ApplicationController
    include V1::Concerns::Auditable
    respond_to :json
    before_filter :find_field, :only => [:show, :update, :destroy]

    def index
      fields = V1::MetadatumField.all
      respond_to do |format|
        format.json do
          render :json => fields, :each_serializer => V1::MetadatumFieldSerializer
        end
      end
    end

    def show
      respond_to do |format|
        format.json do
          if @field
            render :json => @field, :serializer => V1::MetadatumFieldSerializer
          else 
            render :json => {}, :status => 404
          end
        end
      end
    end

    def create
      respond_to do |format|
        format.json do
          @field = V1::MetadatumField.new
          if update_field(@field)
            response.headers['Location'] = metadatum_field_path(@field)
            render :json => @field, :serializer => V1::MetadatumFieldSerializer
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
            render :json => @field, :serializer => V1::MetadatumFieldSerializer
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
      @field = V1::MetadatumField.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @error = "field not found"
    end

    def update_field(field)
      field.assign_attributes(params[:metadatum_field])
      add_audit_params(field)
      field.save
    end

    def conflict?
       return @field.errors[:name] && 
              @field.errors[:name].include?("has already been taken")
    end
  end
end
