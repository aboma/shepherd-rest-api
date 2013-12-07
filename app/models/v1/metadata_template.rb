# == Schema Information
#
# Table name: metadata_templates
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null
#  description   :text
#  deleted_at    :datetime
#  created_by_id :integer          not null
#  updated_by_id :integer
#  deleted_by_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class V1::MetadataTemplate < ActiveRecord::Base
  has_many :metadata_template_field_settings, inverse_of: :metadata_template,
    dependent: :destroy

  attr_accessible :description, :name, :metadata_template_field_settings

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :created_by_id, presence: true
  validates :updated_by_id, presence: true

  validate do |template|
    template.metadata_template_field_settings.each do |setting|
      next if setting.valid?
      setting.errors.messages.each do |msg|
        errors.add(err)
      end
    end
  end

end
