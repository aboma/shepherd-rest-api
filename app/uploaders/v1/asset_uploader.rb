module V1
  class AssetUploader < CarrierWave::Uploader::Base
    include CarrierWave::RMagick
    include CarrierWave::MimeTypes

    storage :file

    process :set_content_type

    # this directory is set in the config/settings.yml file: default is
    # /srv/www/vilio-files
    BASE_DIR = Settings.files_path

    def cache_dir
      "#{Rails.root}/tmp/uploads/#{Rails.env}/files"
    end

    def store_dir
      "#{BASE_DIR}/#{Rails.env}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    version :thumb do
      process :resize_to_limit => [120, 120]
    end

    version :image do
      process :resize_to_limit => [400, 400]
    end
  end
end
