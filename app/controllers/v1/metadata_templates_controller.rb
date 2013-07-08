module V1
  class MetadataTemplatesController < V1::ApplicationController
    include V1::Concerns::Auditable
    before_filter :allow_only_json_requests
  # before_filter :find_template, :only => [:show, :update]

    def index
      templates = V1::MetadataTemplate.all
      respond_to do |format|
        format.json do
          render :json => templates, :each_serializer => V1::MetadataTemplateSerializer
        end
      end
    end

    def create
      respond_to do |format|
        format.json do
          if exists?
            render :json => { :errors => { :name => "template name already exists" } }, :status => :conflict
          else
            template = V1::MetadataTemplate.new
            if update_template(template)
              response.headers['Location'] = metadata_template_path(template)
              render :json => template, :root => "metadata_template", :serializer => V1::MetadataTemplateSerializer
            else 
              render :json => { :errors => template.errors }, :status => :unprocessable_entity
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

    def update_template(template)
      field_settings_params = params[:metadata_template].delete(:metadata_template_field_settings)
      V1::MetadataTemplate.transaction do
        template.attributes = params[:metadata_template]
        add_audit_params(template)
        #update template field settings
        if (field_settings_params)
          specified_settings = []
          field_settings_params.each do |fs_param|
            if fs_param[:id]
              field_setting = template.metadata_template_field_settings.find(fs_param[:id])
              field_setting.assign_attributes(fs_param)
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
        template.save!
      end
      return true
    rescue
      return false
    end

    def exists?
      name = params[:metadata_template][:name]
      return false unless name
      result = V1::MetadataTemplate.find_by_name(name)
      return result.nil? == false
    end
  end
end
