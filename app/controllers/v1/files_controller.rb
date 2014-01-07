module V1
  class FilesController < V1::ApplicationController
    before_filter :find_asset
    respond_to :html, only: [:show]
    respond_to :json, :html, except: [:show]

    # do not list files
    def index
      respond_to do |format|
        format.html { render :html, status: 405 }
        format.json { render :json, status: 405 }
      end
    end

    # Return source file, image. or thumb for file either inline
    # or as attachment
    def show
      respond_to do |format| 
        format.html do
          if @asset
            file_path = get_file_path_requested
            logger.info 'file requested is: ' + file_path
            disposition = params[:download] ? 'attachment' : 'inline'
            content_type = params[:id] == 'file' ? @asset.content_type : determine_content_type(file_path) 
            logger.info "sending file from location #{file_path} as #{content_type}"
            send_file file_path, type: content_type, disposition: disposition 
          else
            render :html, status: :not_found
          end
        end
      end

    end

    # do not allow the creation of files outside of asset creation
    def create
      respond_to do |format|
        format.html { render :html, status: 405 }
        format.json { render :json, status: 405 }
      end
    end

    # do not allow the update of files outside of asset update
    def update
      respond_to do |format|
        format.html { render :html, status: 405 }
        format.json { render :json, status: 405 }
      end
    end

    # do not allow the deletion of files outside of asset delete
    def delete
      respond_to do |format|
        format.html { render :html, status: 405 }
        format.json { render :json, status: 405 }
      end
    end

  private

    def get_file_path_requested
      return @asset.file.image.path if params[:id] == 'image'
      return @asset.file.thumb.path if params[:id] == 'thumb'
      return @asset.file.path
    end

    def find_asset
      @asset = V1::Asset.find(params[:asset_id])
    rescue ActiveRecord::RecordNotFound
      @error = { asset: 'asset not found' }
    end

    def determine_content_type(filename)
      extname = File.extname(filename)[1..-1]
      mime_type = Mime::Type.lookup_by_extension(extname)
      return mime_type.to_s unless mime_type.nil?
      return nil
    end
  end
end
