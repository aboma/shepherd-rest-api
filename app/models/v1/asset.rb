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

    has_many :relationships, :dependent => :destroy
    has_many :portfolios, :through => :relationships

    attr_accessible :name, :file, :description, :deleted_by_id, :deleted_at  

    validates :name, :presence => true, :uniqueness => { :case_sensitive => false }
    validates :created_by_id, :presence => true
    validates :updated_by_id, :presence => true

    # mount Carrierwave uploader for file uploads
    mount_uploader :file, V1::AssetUploader
  end
end
