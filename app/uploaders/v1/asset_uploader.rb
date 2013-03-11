module V1
  class AssetUploader < CarrierWave::Uploader::Base
    include CarrierWave::RMagick
  
    storage :file

    def store_dir
      "files/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  
    version :thumb do
      process :resize_to_limit => [200, 200]
    end
  end
end