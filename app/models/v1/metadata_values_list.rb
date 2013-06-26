# == Schema Information
#
# Table name: metadata_values_lists
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null
#  description   :string(255)
#  deleted_at    :datetime
#  created_by_id :integer          not null
#  updated_by_id :integer
#  deleted_by_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

module V1
  class MetadataValuesList < ActiveRecord::Base
    has_many :fields, :class_name => "V1::MetadataField", :inverse_of => :allowed_values_list
    has_many :metadata_list_values, :class_name => "V1::MetadataListValue", :inverse_of => :metadata_values_list,
      :dependent => :destroy

    attr_accessible :name, :description, :fields

    validates :name, :presence => true, :uniqueness => { :case_sensitive => false }
    validates :created_by_id, :presence => true
    validates :updated_by_id, :presence => true
  end
end
