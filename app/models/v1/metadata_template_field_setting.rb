# == Schema Information
#
# Table name: metadata_template_field_settings
#
#  id                   :integer          not null, primary key
#  metadata_field_id    :integer          not null
#  metadata_template_id :integer          not null
#  required             :boolean          not null
#  order                :integer          not null
#  deleted_at           :datetime
#  created_by_id        :integer          not null
#  updated_by_id        :integer
#  deleted_by_id        :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class V1::MetadataTemplateFieldSetting < ActiveRecord::Base
  belongs_to :metadata_template, :inverse_of => :metadata_template_field_settings 
  belongs_to :metadata_field

  attr_accessible :metadata_field_id, :required, :order, :metadata_template

  validates :metadata_field_id, :presence => true
  validates_inclusion_of :required, in: [true, false]
  validates :order, :presence => true

  validates :created_by_id, :presence => true
  validates :updated_by_id, :presence => true

end
