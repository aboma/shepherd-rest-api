class V1::MetadataTemplateFieldSetting < ActiveRecord::Base
  belongs_to :metadata_template, :inverse_of => :metadata_template_field_settings 

  attr_accessible :field_id, :required, :order, :metadata_template

  validates :field_id, :presence => true
  validates_inclusion_of :required, in: [true, false]
  validates :order, :presence => true

  validates :created_by_id, :presence => true
  validates :updated_by_id, :presence => true

end
