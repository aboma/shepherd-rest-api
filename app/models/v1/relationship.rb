# == Schema Information
#
# Table name: relationships
#
#  id            :integer          not null, primary key
#  asset_id      :integer          not null
#  portfolio_id  :integer          not null
#  deleted_at    :datetime
#  created_by_id :integer          not null
#  updated_by_id :integer
#  deleted_by_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

module V1
  class Relationship < ActiveRecord::Base
    belongs_to :portfolio
    belongs_to :asset  #, :class_name => "Asset", :foreign_key => :relationship_id

    attr_accessible :asset_id, :portfolio_id 

    validates :asset, :existence => true
    validates :portfolio, :existence => true

    validates :created_by_id, :presence => true
    validates :updated_by_id, :presence => true
  end
end
