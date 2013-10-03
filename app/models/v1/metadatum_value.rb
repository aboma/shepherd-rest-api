# == Schema Information
#
# Table name: metadatum_values
#
#  id                 :integer          not null, primary key
#  asset_id           :integer          not null
#  metadatum_field_id :integer          not null
#  metadatum_value    :string(255)      not null
#  created_by_id      :integer          not null
#  updated_by_id      :integer
#  deleted_by_id      :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

module V1
  class MetadatumValue < ActiveRecord::Base
    belongs_to :asset, :class_name => "V1::Asset", :inverse_of => :metadata
    belongs_to :metadatum_field, :class_name => "V1::MetadatumField"

    attr_accessible :asset_id, :metadatum_field_id, :metadatum_value

    validates :asset_id, :existence => true
    validates :metadatum_field_id, :existence => true

    validates :metadatum_value, :presence => true, :valid_metadatum_value => true
    validates :created_by_id, :presence => true
    validates :updated_by_id, :presence => true

  end
end
