module V1
  class AssetSerializer < V1::LuxinSerializer
    include Rails.application.routes.url_helpers
      
    attributes :id, :name, :description, :file
    
    def attributes
      hash = super
      hash[:links] = [
        { :rel => 'self', :href => assets_path(asset) }
        #  :rel => 'thumbnail', href => :thumbnail_path }
      ]
      hash
    end
  end
end