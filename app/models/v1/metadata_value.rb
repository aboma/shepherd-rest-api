module V1
  class MetadataValue < ActiveRecord::Base
    validates :value, :presence => true, :uniqueness => { :case_sensitive => false }
    validates :created_by_id, :presence => true
    validates :updated_by_id, :presence => true
  end
end