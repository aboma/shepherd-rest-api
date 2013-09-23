# == Schema Information
#
# Table name: assets
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null
#  file          :string(255)      not null
#  description   :string(255)
#  deleted_at    :datetime
#  created_by_id :integer          not null
#  updated_by_id :integer
#  deleted_by_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

# == Schema Information
#
# Table name: assets
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null
#  file          :string(255)      not null
#  description   :string(255)
#  deleted_at    :datetime
#  created_by_id :integer          not null
#  updated_by_id :integer
#  deleted_by_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
module V1
  class Asset < ActiveRecord::Base
    before_save :update_asset_attributes

    has_many :relationships, :dependent => :destroy
    has_many :portfolios, :through => :relationships
    has_many :metadata, :class_name => "V1::MetadatumValue", :dependent => :destroy

    attr_accessible :name, :file, :description, :metadata, :deleted_by_id, :deleted_at  

    validates :name, :presence => true, :uniqueness => { :case_sensitive => false }

    validates :created_by_id, :presence => true
    validates :updated_by_id, :presence => true

    # mount Carrierwave uploader for file uploads
    mount_uploader :file, V1::AssetUploader

    # merge child error messages
    validate do |asset|
      asset.errors.delete(:metadata)
      asset.metadata.each do |metadatum|
        next if metadatum.valid?
        asset.errors.add(:metadata, metadatum.errors)
      end
    end

  private 

    # set mime type and file size attributes on file field
    def update_asset_attributes
      if file.present? && file_changed?
        self.content_type = file.file.content_type if file.file.content_type
        self.size = file.file.size if file.file.size
      end
    end
  end
end
