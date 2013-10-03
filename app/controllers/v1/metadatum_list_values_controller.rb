module V1
  class MetadatumListValuesController < V1::ApplicationController
    include V1::Concerns::Auditable
    before_filter :allow_only_json_requests
    before_filter :find_value, :only => [:show]

    def index
      values = MetadatumListValue.all
      respond_to do |format|
        format.json do
          render :json => values, :root => "metadatum_list_values", :each_serializer => V1::MetadatumListValueSerializer
        end        
      end
    end

    def show
      respond_to do |format|
        format.json do
          if @value
            render :json => @value, :root => "metadatum_list_value", :serializer => V1::MetadatumListValueSerializer
          else
            render :json => {}, :status => 404
          end
        end
      end
    end


    def create 
      respond_to do |format|
        format.json do
          value = V1::MetadatumListValue.new
          if update_value(value)
            response.headers["Location"] = metadatum_list_value_path(value)
            render :json => value, :root => "metadatum_list_value", :serializer => V1::MetadatumListValueSerializer
          else
            render :json => { :errors => value.errors }, :status => :unprocessable_entity
          end
        end
      end
    end

  private

    def find_field
      @value = V1::MetadatumListValue.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @error = { :id => "value not found" }
    end

    def update_value(value)
      value.attributes = params[:metadatum_list_value]
      add_audit_params(value)
      value.save
    end

  end
end
