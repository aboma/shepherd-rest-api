class CreateMetadataTemplateFieldSettings < ActiveRecord::Migration
  def up
    create_table :metadata_template_field_settings do |t|
      t.integer   :metadata_field_id,       :null => false
      t.integer   :metadata_template_id,    :null => false
      t.boolean   :required,                :null => false
      t.integer   :order,                   :null => false
      t.datetime  :deleted_at,              :default => nil
      t.integer   :created_by_id,           :null => false
      t.integer   :updated_by_id,           :default => nil
      t.integer   :deleted_by_id,           :default => nil

      t.timestamps
    end
  end

  def down
    drop_table :metadata_template_field_settings
  end
end
