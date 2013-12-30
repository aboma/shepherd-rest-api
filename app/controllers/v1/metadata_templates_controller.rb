module V1
  class MetadataTemplatesController < V1::ApplicationController
    include V1::Concerns::Auditable
    respond_to :json
    before_filter :find_template, only: [:show, :update, :destroy]

    def index
      templates = V1::MetadataTemplate.all
      respond_to do |format|
        format.json do
          render json: templates, each_serializer: V1::MetadataTemplateSerializer
        end
      end
    end

    def show 
      respond_to do |format|
        format.json do
          if @template
            render json: @template, each_serializer: V1::MetadataTemplateSerializer
          else
            render json: nil, status: :not_found
          end
        end
      end
    end

    def create
      @template = V1::MetadataTemplate.new
      respond_to do |format|
        format.json do
          if update_template(@template)
            response.headers['Location'] = metadata_template_path(@template)
            render json: @template, serializer: V1::MetadataTemplateSerializer, status: :created
          else 
            status = conflict? ? :conflict : :unprocessable_entity
            render json: { errors: @template.errors }, status: status 
          end
        end
      end
    end

    def update
      respond_to do |format|
        format.json do
          unless @template
            render json: nil, status: :not_found
            return
          end
          if update_template(@template)
            render json: @template, serializer: V1::MetadataTemplateSerializer
          else
            status = conflict? ? :conflict : :unprocessable_entity
            render json: { errors: @template.errors }, status: status
          end
        end
      end
    end

    def destroy
      respond_to do |format|
        format.json do
          render json: nil, status: 404 unless @template
          if @template
            @template.destroy
            if @template.destroyed?
              render json: nil, status: :ok
            else
              render json: { error: @template.errors }, status: 500
            end
          end
        end
      end
    end


    private 

    def find_template
      @template = MetadataTemplate.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @error = { :id => "template not found" }
    end

    # update template and field settings relation as part of a transaction
    def update_template(template)
      field_settings_params = params[:metadata_template].delete(:metadata_template_field_settings)
      V1::MetadataTemplate.transaction do
        template.attributes = params[:metadata_template]
        add_audit_params(template)
        update_field_settings(template, field_settings_params)
        template.save!
      end
      return true
    rescue
      return false
    end

    # update field settings relation of template
    def update_field_settings(template, fs_params)
      if (fs_params)
        specified_settings = []
        fs_params.each do |fs_param|
          if fs_param[:id]
            field_setting = template.metadata_template_field_settings.find(fs_param[:id])
            field_setting.update_attributes(fs_param)
          else
            field_setting = template.metadata_template_field_settings.build(fs_param)
          end
          field_setting.required = ActiveRecord::ConnectionAdapters::Column.value_to_boolean(fs_param[:required])
          add_audit_params(field_setting)
          specified_settings << field_setting
        end
        template.metadata_template_field_settings.each do |existing_setting|
          existing_setting.destroy unless specified_settings.include?(existing_setting)
        end
      end
    end

    def conflict?
       return @template.errors[:name] && 
              @template.errors[:name].include?("has already been taken")
    end

  end
end
