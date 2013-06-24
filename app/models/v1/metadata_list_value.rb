# == Schema Information
#
# Table name: metadata_values
#
#  id            :integer          not null, primary key
#  value         :string(255)      not null
#  description   :string(255)
#  deleted_at    :datetime
#  created_by_id :integer          not null
#  updated_by_id :integer
#  deleted_by_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

module V1
  class MetadataListValue < ActiveRecord::Base

    attr_accessible :value, :updated_by_id, :created_by_id

    validates :value, :presence => true
    validates :created_by_id, :presence => true
    validates :updated_by_id, :presence => true
  end
end
