module V1
  class FilesController < V1::ApplicationController
    before_filter :find_asset

    def show
      respond_to do |format| 
        format.html do
          if @asset
            mime = MIME::Types.type_for(@asset.file.file).first.content_type
            send_file file, :type => mime, :disposition => 'attachment'
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
