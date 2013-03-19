module V1
  class AssetSerializer < V1::VilioSerializer
    include Rails.application.routes.url_helpers
    
    attributes :id, :name, :description, :filename
    
    def attributes
      hash = super
      thumbnail_url = File.join(root_url, object.file.thumb.url);
      aid = id || object.id
      hash[:links] = [
        { :rel => 'self', :href => asset_url(:id => aid) },
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