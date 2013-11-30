module V1
  class MetadataTemplateFieldSettingsController < V1::ApplicationController
    include V1::Concerns::Auditable
    respond_to :json
  # before_filter :find_setting, :only => [:show, :update]

    def index
      settings = V1::MetadataTemplateFieldSetting.all
      respond_to do |format|
        format.json do
          render :json => settings, :each_serializer => V1::MetadataTemplateFieldSettingSerializer
        end
      end
    end

    private 

    def find_setting
      @setting = MetadataTemplateFieldSetting.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @error = { :id => "template field setting not found" }
    end

    def update_setting(setting)
      setting.attributes = params[:metadata_template_field_setting]
      add_audit_params(setting)
      setting.save
    end
  end
end
