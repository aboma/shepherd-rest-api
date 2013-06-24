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
    belongs_to :metadata_values_list

    attr_accessible :value, :metadata_values_list_id

    validates :value, :presence => true
    validates :metadata_values_list, :presence => true
    validates :created_by_id, :presence => true
    validates :updated_by_id, :presence => true
  end
end
