module V1
  class FilesController < V1::ApplicationController
    before_filter :find_asset

    def show
      respond_to do |format| 
        format.html do
          if @asset
            file = @asset.file.path
            file = @asset.file.image.path if params[:id] == 'image'
            file = @asset.file.thumb.path if params[:id] == 'thumb'
            disposition = params[:download] ? "attachment" : "inline"
            content_type = params[:id] == "file" ? @asset.content_type : determine_content_type(file) 
            logger.info "sending file from location #{file} as #{content_type}"
            send_file @asset.file.path, :type => content_type, :disposition => disposition 
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

    def determine_content_type(filename)
      extname = File.extname(filename)[1..-1]
      mime_type = Mime::Type.lookup_by_extension(extname)
      return mime_type.to_s unless mime_type.nil?
      return nil
    end
  end
end
