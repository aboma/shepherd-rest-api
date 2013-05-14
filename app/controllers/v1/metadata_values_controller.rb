module V1
  class MetadataValuesController < V1::ApplicationController
    include V1::Concerns::Auditable
    before_filter :allow_only_json_requests
    before_filter :find_value, :only => [:show]

    def index
      values = MetadataValue.all
      respond_to do |format|
        format.json do
          render :json => values, :each_serializer => V1::MetadataValueSerializer
        end        
      end
    end

    def show
      respond_to do |format|
        format.json do
          if @value
            render :json => @value, :root => "value", :serializer => V1::MetadataValueSerializer
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
            render :json => { :error => "value already exists" }, :status => :conflict
          else
            value = V1::MetadataValue.new
            if update_value(value)
              response.headers["Location"] = metadata_value_path(value)
              render :json => value, :root => "value", :serializer => V1::MetadataValueSerializer
            else
              render :json => { :error => value.errors }, :status => :unprocessable_entity
            end
          end
        end
      end
    end

  private

    def find_field
      @value = V1::MetadataField.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @error = "value not found"
    end

    def update_value(value)
      value.attributes = add_audit_params(value, params[:value])
      value.save!
      return true
    rescue => e
      logger.error("error creating value #{e}")
      return false;
    end

    def exists?
      value = params[:value][:value] 
      logger.info("VALUE IS #{value}")
      return false unless value
      result = V1::MetadataValue.find_by_value(value)
      return result.nil? == false 
    end

  end
end
