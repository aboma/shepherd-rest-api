module V1
  class AssetSerializer < V1::VilioSerializer
    include Rails.application.routes.url_helpers

    attributes :id, :name, :description, :filename, :metadata

    has_many :metadata, :serializer => V1::MetadatumSerializer, :embed => :objects

    def attributes
      hash = super
      thumbnail_url = File.join(root_url, object.file.thumb.url)
      image_url = File.join(root_url, object.file.url)
      aid = id || object.id
      hash[:links] = [
        { :rel => 'self', :href => asset_url(:id => aid) },
        { :rel => 'thumbnail', :href => "#{thumbnail_url}" },
        { :rel => "image", :href => "#{image_url}" },
        { :rel => "file", :href => asset_file_url(aid, 1) }
      ]
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
