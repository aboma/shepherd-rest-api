# == Schema Information
#
# Table name: metadatum_values_lists
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
  class MetadatumValuesList < ActiveRecord::Base
    has_many :fields, :class_name => "V1::MetadatumField", :inverse_of => :allowed_values_list
    has_many :metadatum_list_values, :class_name => "V1::MetadatumListValue", :inverse_of => :metadatum_values_list,
      :dependent => :destroy

    attr_accessible :name, :description, :fields

    validates :name, :presence => true, :uniqueness => { :case_sensitive => false }
    validates :created_by_id, :presence => true
    validates :updated_by_id, :presence => true
  end
end
