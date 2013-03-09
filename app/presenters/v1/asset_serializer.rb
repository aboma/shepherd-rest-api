module V1
  class AssetSerializer < V1::LuxinSerializer
    include Rails.application.routes.url_helpers
      
    attributes :id, :name, :description, :file_path, :filename
    
    def attributes
      hash = super
      hash[:links] = [
        { :rel => 'self', :href => assets_path(asset) },
        { :rel => 'thumbnail', :href => "#{object.file.thumb.url}" }
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