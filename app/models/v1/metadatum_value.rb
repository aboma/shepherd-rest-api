# == Schema Information
#
# Table name: metadatum_values
#
#  id                :integer          not null, primary key
#  asset_id          :integer          not null
#  metadata_field_id :integer          not null
#  value             :string(255)      not null
#  created_by_id     :integer          not null
#  updated_by_id     :integer
#  deleted_by_id     :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

module V1
  class MetadatumValue < ActiveRecord::Base
    belongs_to :asset, :class_name => "V1::Asset"
    belongs_to :metadata_field, :class_name => "V1::MetadataField"

    attr_accessible :asset_id, :metadata_field_id, :value

    validates :asset_id, :existence => true
    validates :metadata_field_id, :existence => true

    validates :value, :presence => true
    validates :created_by_id, :presence => true
    validates :updated_by_id, :presence => true

  end
end
