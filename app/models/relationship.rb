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

class Relationship < ActiveRecord::Base
  belongs_to :portfolio
  belongs_to :asset, :class_name => "Asset", :foreign_key => :relationship_id
  
  validates asset_id, :presence => true
  validates portfolio_id, :presence => true
end
