class V1::MetadataTemplate < ActiveRecord::Base
  attr_accessible :description, :name

  validates :name, :presence => true, :uniqueness => { :case_sensitive => false }
  validates :created_by_id, :presence => true
  validates :updated_by_id, :presence => true

end
