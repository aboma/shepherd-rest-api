module V1
  class AssetUploader < CarrierWave::Uploader::Base
    include CarrierWave::RMagick
  
    storage :file

    def cache_dir
      "#{Rails.root}/tmp/uploads/#{Rails.env}/files"
    end

    def store_dir
      "files/#{Rails.env}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  
    version :thumb do
      process :resize_to_limit => [120, 120]
    end
  end
end