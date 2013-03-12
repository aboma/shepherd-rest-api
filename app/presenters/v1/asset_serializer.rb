module V1
  class AssetSerializer < V1::LuxinSerializer
    include Rails.application.routes.url_helpers
    include ActionController
    
    attributes :id, :name, :description, :file_path, :filename
    
    def attributes
      hash = super
      thumbnail_url = File.join(root_url, object.file.thumb.url);
      hash[:links] = [
        { :rel => 'self', :href => assets_url(asset) },
        { :rel => 'thumbnail', :href => "#{thumbnail_url}" }
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