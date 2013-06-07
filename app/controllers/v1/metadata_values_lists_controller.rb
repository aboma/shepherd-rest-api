module V1
  class MetadataValuesListsController < V1::ApplicationController
    include V1::Concerns::Auditable
    before_filter :allow_only_json_requests
    before_filter :find_list, :only => [:show]

    def index
      lists = V1::MetadataValuesList.all
      respond_to do |format|
        format.json do
          render :json => lists, :root => "metadata_values_lists", :each_serializer => V1::MetadataValuesListSerializer
        end
      end
    end

    def show
      respond_to do |format|
        format.json do
          if @list
            render :json => @list, :root => "metadata_values_list", :serializer => V1::MetadataValuesListSerializer
          else
            render :json => {}, :status => :not_found
          end
        end
      end
    end

    def create
      respond_to do |format|
        format.json do
          if exists?
            render :json => { :error => "list already exists with that name" }, :status => :conflict
          else
            list = V1::MetadataValuesList.new
            if update_list(list)
              response.headers["Location"] = metadata_values_list_path(list)
              render :json => list, :root => "metadata_values_list", :serializer => V1::MetadataValuesListSerializer
            else
              render :json => { :error => list.errors }, :status => :unprocessable_entity
            end
          end
        end
      end
    end


  private

    def exists?
      name = params[:metadata_values_list][:name]
      return false unless name
      result = V1::MetadataValuesList.find_by_name(name)
      return result.nil? == false
    end

    def find_list
      @list = V1::MetadataValuesList.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @error = "list not found"
    end

    def update_list(list)
      list.attributes = add_audit_params(list, params[:metadata_values_list])
      list.save
    end
  end
end
