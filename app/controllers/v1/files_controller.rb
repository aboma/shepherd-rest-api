module V1
  class FilesController < V1::ApplicationController
    before_filter :find_asset

    def show
      respond_to do |format| 
        format.html do
          if @asset
            logger.info "sending file from location #{@asset.file.path} as attachment"
            send_file @asset.file.path, :type => @asset.content_type, :disposition => 'attachment'
          else
            render :html, :status => :not_found
          end
        end
      end

    end

  private

    def find_asset
      @asset = V1::Asset.find(params[:asset_id])
    rescue ActiveRecord::RecordNotFound
      @error = { :asset => "asset not found" }
    end
  end
end
