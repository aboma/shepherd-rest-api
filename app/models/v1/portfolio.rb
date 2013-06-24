# == Schema Information
#
# Table name: portfolios
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null
#  description   :string(255)
#  created_by_id :integer          not null
#  updated_by_id :integer
#  deleted_by_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

# == Schema Information
#
# Table name: portfolios
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null
#  description   :string(255)
#  deleted_at    :datetime
#  created_by_id :integer          not null
#  updated_by_id :integer
#  deleted_by_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
module V1
  class Portfolio < ActiveRecord::Base

    has_many :relationships, :dependent => :destroy
    has_many :assets, :through => :relationships, :source => :asset
  #           :conditions => "relationship.relationship_type = 'Asset'"

    attr_accessible :name, :description, :created_at, :updated_at 

    validates :name, :presence => true, :uniqueness => { :case_sensitive => false }
    validates :created_by_id, :presence => true
    validates :updated_by_id, :presence => true

  end
end
