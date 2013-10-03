# == Schema Information
#
# Table name: metadatum_list_values
#
#  id                      :integer          not null, primary key
#  value                   :string(255)      not null
#  description             :string(255)
#  metadatum_values_list_id :integer
#  deleted_at              :datetime
#  created_by_id           :integer          not null
#  updated_by_id           :integer
#  deleted_by_id           :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

module V1
  class MetadatumListValue < ActiveRecord::Base
    belongs_to :metadatum_values_list

    attr_accessible :value, :metadatum_values_list_id

    validates :value, :presence => true
    validates :metadatum_values_list_id, :existence => true
    validates :created_by_id, :presence => true
    validates :updated_by_id, :presence => true
  end
end
