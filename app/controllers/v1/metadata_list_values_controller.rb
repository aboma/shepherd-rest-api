module V1
  class MetadataListValuesController < V1::ApplicationController
    include V1::Concerns::Auditable
    before_filter :allow_only_json_requests
    before_filter :find_value, :only => [:show]

    def index
      values = MetadataListValue.all
      respond_to do |format|
        format.json do
          render :json => values, :root => "metadata_list_values", :each_serializer => V1::MetadataListValueSerializer
        end        
      end
    end

    def show
      respond_to do |format|
        format.json do
          if @value
            render :json => @value, :root => "metadata_list_value", :serializer => V1::MetadataListValueSerializer
          else
            render :json => {}, :status => 404
          end
        end
      end
    end


    def create 
      respond_to do |format|
        format.json do
          value = V1::MetadataListValue.new
          if update_value(value)
            response.headers["Location"] = metadata_list_value_path(value)
            render :json => value, :root => "metadata_list_value", :serializer => V1::MetadataListValueSerializer
          else
            render :json => { :errors => value.errors }, :status => :unprocessable_entity
          end
        end
      end
    end

  private

    def find_field
      @value = V1::MetadataListValue.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @error = { :id => "value not found" }
    end

    def update_value(value)
      value.attributes = add_audit_params(value, params[:metadata_list_value])
      value.save!
      return true
    rescue => e
      logger.error("error creating value #{e}")
      return false
    end

  end
end
