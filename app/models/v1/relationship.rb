# == Schema Information
#
# Table name: relationships
#
#  id                :integer          not null, primary key
#  relationship_type :string(255)
#  asset_id          :integer
#  portfolio_id      :integer
#  deleted_at        :datetime
#  created_by_id     :integer          not null
#  updated_by_id     :integer
#  deleted_by_id     :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

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
    
    validates :asset, :presence => true
    validates :portfolio, :presence => true
    
    validates :created_by_id, :presence => true
    validates :updated_by_id, :presence => true
  end
end
