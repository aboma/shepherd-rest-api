module V1
  class MetadataField < ActiveRecord::Base
    
    validates :name, :presence => true, :uniqueness => { :case_sensitive => false }
    validates :type, :presence => true
    validates :created_by_id, :presence => true
    validates :updated_by_id, :presence => true
    
  end
end