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
    has_many :metadata_template_field_settings, :class_name => "V1::MetadataTemplateFieldSetting",
      :dependent => :restrict
    belongs_to :allowed_values_list, :class_name => "V1::MetadataValuesList", :inverse_of => :fields

    attr_accessible :name, :description, :type, :allowed_values_list_id

    validates :name, :presence => true, :uniqueness => { :case_sensitive => false }
    validates :type, :inclusion => { :in => Settings.field_types,
      message: "%{value} is not in list: #{Settings.field_types}" }
    validates :allowed_values_list_id, :existence => { :allow_nil => true, :both => false }
    validates :created_by_id, :presence => true
    validates :updated_by_id, :presence => true

  end
end
