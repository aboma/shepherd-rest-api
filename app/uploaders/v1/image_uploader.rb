module V1
  class ImageUploader < CarrierWave::Uploader::Base
    include CarrierWave::RMagick
  
    storage :file

    # store files in rails root rather than application public directory
    # so that files are not deleted on application upgrade
    def store_dir
      "#{Rails.root.join('public', 'vilio', 'uploads')}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  
    version :thumb do
      process :resize_to_limit => [200, 200]
    end
  end
end