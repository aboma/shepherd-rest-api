# == Schema Information
#
# Table name: relationships
#
#  id                :integer         not null, primary key
#  relationship_id   :integer
#  relationship_type :string(255)
#  asset_id          :integer
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#
module V1
  class Relationship < ActiveRecord::Base
    belongs_to :portfolio
    belongs_to :asset  #, :class_name => "Asset", :foreign_key => :relationship_id
    
    attr_accessible :asset_id, :portfolio_id, :created_by_id, :updated_by_id, :relationship_type
    
    validates :asset_id, :presence => true
    validates :portfolio_id, :presence => true
    
    validates_associated :portfolio
    validates_associated :asset
  end
end