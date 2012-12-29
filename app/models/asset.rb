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

class Asset < ActiveRecord::Base
  
  has_many :relationships, :dependent => :destroy
  has_many :portfolios, :through => :relationships
  
  attr_accessible :name, :file, :description, :created_by_id, :updated_by_id, :deleted_by_id, :deleted_at  
    
  validates :name, :presence => true, :uniqueness => { :case_sensitive => false }
  
  # create a relationship between a portfolio and this asset
  def relate!(portfolio)
    relationships.create(:portfolio_id => portfolio.id, :relationship_type => 'Asset') 
  end
  
  # return all portfolios that this asset is associated with
  def portfolios
    #relationships.find_by_asset_id(self.id)
    relationships.find(:all, :params => { :asset_id => self.id })
  end
  
  # mount Carrierwave uploader for file uploads
  mount_uploader :file, V1::ImageUploader
end
