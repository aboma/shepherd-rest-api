module V1
  class MetadatumValuesListsController < V1::ApplicationController
    include V1::Concerns::Auditable
    before_filter :find_list, :only => [:show, :update, :destroy]
    respond_to :json

    def index
      lists = V1::MetadatumValuesList.all
      respond_to do |format|
        format.json do
          render json: lists, root: 'metadatum_values_lists', :each_serializer => V1::MetadatumValuesListSerializer
        end
      end
    end

    def show
      respond_to do |format|
        format.json do
          if @list
            render json: @list, root: 'metadatum_values_list', serializer: V1::MetadatumValuesListSerializer
          else
            render json: nil, status: :not_found
          end
        end
      end
    end

    def create
      respond_to do |format|
        format.json do
          if exists?
            render json: { errors: { name: 'list already exists with that name' } }, status: :conflict
          else
            list = V1::MetadatumValuesList.new
            if update_list(list)
              response.headers['Location'] = metadatum_values_list_path(list)
              render json: list, root: 'metadatum_values_list', serializer: V1::MetadatumValuesListSerializer
            else
              render json: { errors: list.errors }, status: :unprocessable_entity
            end
          end
        end
      end
    end

    def update
      respond_to do |format|
        format.json do
          if @list && update_list(@list)
            render json: @list, root: 'metadatum_values_list', serializer: V1::MetadatumValuesListSerializer
          else
            render json: { errors: { id: 'metadata values list not found' } }, status: 404 unless @list
            render json: { errors: @list.errors }, status: :unprocessable_entity if @list
          end
        end
      end
    end

    def destroy
      respond_to do |format|
        format.json do
          render json: { errors: { id: 'metadata values list not found' } }, status: 404 unless @list
          if @list
            @list.destroy
            if @list.destroyed?
              render json: nil, status: :ok
            else
              render json: { error: @list.errors }, status: :unprocessable_entity
            end
          end
        end        
      end
    end


  private

    def exists?
      name = params[:metadatum_values_list][:name]
      return false unless name
      result = V1::MetadatumValuesList.find_by_name(name, :conditions => ['lower(name) = ?', name.downcase])
      return result.nil? == false
    end

    def find_list
      @list = V1::MetadatumValuesList.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @error = 'list not found'
    end

    # update list and any list values included as part of a transaction
    def update_list(list)
      values_params = params[:metadatum_values_list].delete(:metadatum_list_values)
      V1::MetadatumValuesList.transaction do
        list.attributes = params[:metadatum_values_list]
        add_audit_params(list)
        list.save!
        # update list values
        if (values_params) 
          specified_values = []
          values_params.each do |value_params|
            if value_params[:id]
              value = list.metadatum_list_values.find(value_params[:id])
              add_audit_params(value)
              value.update_attributes(value_params)
            else 
              value = list.metadatum_list_values.build(value_params)
              add_audit_params(value)
              value.save!
            end
            specified_values << value
          end
          list.metadatum_list_values.each do |existing_value|
            existing_value.destroy unless specified_values.include?(existing_value)
          end
        end
        list.reload
      end
      return true
    rescue
      return false
    end
  end
end
