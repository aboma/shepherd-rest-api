# == Schema Information
#
# Table name: metadata_fields
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  description            :string(255)
#  type                   :string(255)
#  allowed_values_list_id :integer
#  deleted_at             :datetime
#  created_by_id          :integer          not null
#  updated_by_id          :integer
#  deleted_by_id          :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

module V1
  class MetadataField < ActiveRecord::Base
    self.inheritance_column = nil

    belongs_to :allowed_values_list, :class_name => "MetadataValuesList"

    attr_accessible :name, :description, :type, :created_at, :created_by_id, :updated_at, :updated_by_id

    validates :name, :presence => true, :uniqueness => { :case_sensitive => false }
    validates :type, inclusion: { in: %w(string boolean integer date),
      message: "%{value} is not in list: string, boolean, integer, date" }
    validates :created_by_id, :presence => true
    validates :updated_by_id, :presence => true

  end
end
