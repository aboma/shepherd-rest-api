# == Schema Information
#
# Table name: assets
#
#  id            :integer         not null, primary key
#  name          :string(255)
#  filename      :string(255)
#  description   :string(255)
#  deleted_at    :datetime
#  created_by_id :integer
#  updated_by_id :integer
#  deleted_by_id :integer
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

class Asset < ActiveRecord::Base
  authenticates_with_sorcery!
    
  attr_accessible :name, :filename, :description, :created_by_id, :updated_by_id, :deleted_by_id, :deleted_at  
    
  validates :name, :presence => true, :uniqueness => { :case_sensitive => false }
    
  mount_uploader :filename, V1::ImageUploader
end
