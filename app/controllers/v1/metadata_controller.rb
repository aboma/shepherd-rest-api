module V1
  class MetadataController < V1::ApplicationController
    include V1::Concerns::Auditable
    before_filter :find_asset
    respond_to :json

    def index
      respond_to do |format|
        format.json do
          render json: @asset.metadata, root: :metadata, each_serializer: V1::MetadatumSerializer if @asset
          render json: { error: 'asset not found' }, status: :not_found unless @asset
        end
      end
    end

  private

    def find_asset
      @asset = V1::Asset.find(params[:asset_id])
    end
  end
end
