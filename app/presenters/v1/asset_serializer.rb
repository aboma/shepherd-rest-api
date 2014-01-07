module V1
  class AssetSerializer < V1::ShepherdSerializer
    include Rails.application.routes.url_helpers

    attributes :id, :name, :description, :filename, :size, :content_type, :image, :thumbnail, :file, :metadata

    has_many :metadata, serializer: V1::MetadatumSerializer, embed: :objects
    has_many :portfolios, serializer: V1::PortfolioSerializer,  embed: :ids, include: false

    def asset_id
      id || object.id
    end

    def attributes
      hash = super
      hash[:links] = {
        self: asset_url({ id: asset_id }),
        metadata: asset_metadata_url({ asset_id: asset_id })
      }
      hash
    end

    def filename
      "#{object.file.file.filename}"
    end

    def image
      asset_file_url({ :asset_id => asset_id, :id => 'image', :format => nil })
    end

    def thumbnail
      asset_file_url({ :asset_id => asset_id, :id => 'thumb', :format => nil })
    end

    def file
      asset_file_url({ :asset_id => asset_id, :id => 'file', :format => nil, :download => true })
    end
  end
end
