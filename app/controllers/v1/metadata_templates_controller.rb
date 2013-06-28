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

    private 

    def find_setting
      @template = MetadataTemplate.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @error = { :id => "template not found" }
    end

    def update_setting(setting)
      setting.attributes = params[:metadata_template]
      add_audit_params(setting)
      setting.save
    end
  end
end
