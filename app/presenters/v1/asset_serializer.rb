module V1
  class AssetSerializer < V1::ShepherdSerializer
    include Rails.application.routes.url_helpers

    attributes :id, :name, :description, :filename, :size, :content_type, :metadata

    has_many :metadata, serializer: V1::MetadatumSerializer, embed: :objects
    #has_many :relationships, :serializer => V1::RelationshipSerializer, :embed => :ids
    has_many :portfolios, serializer: V1::PortfolioSerializer,  embed: :ids, include: false


    def attributes
      hash = super
      asset_id = id || object.id
      hash[:links] = {
        self: asset_url({ id: asset_id }),
        thumbnail: asset_file_url({ :asset_id => asset_id, :id => 'thumb', :format => nil }),
        image: asset_file_url({ :asset_id => asset_id, :id => 'image', :format => nil }),
        file: asset_file_url({ :asset_id => asset_id, :id => 'file', :format => nil, :download => true })
      }
      hash
    end

    def filename
      "#{object.file.file.filename}"
    end

    def file_path
      "#{object.file.url}"
    end

  end
end
