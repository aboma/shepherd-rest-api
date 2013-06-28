class V1::MetadataTemplateFieldSetting < ActiveRecord::Base
  attr_accessible :field_id, :required, :order

  validates :field_id, :presence => true
  validates :required, :presence => true
  validates :order, :presence => true

  validates :created_by_id, :presence => true
  validates :updated_by_id, :presence => true

end
