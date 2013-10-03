class AddMetadatumFields < ActiveRecord::Migration
  def up
    create_table :metadatum_fields do |t|
      t.string    :name,                    :null => :false
      t.string    :description,             :null => :false
      t.string    :type,                    :null => :false
      t.integer   :allowed_values_list_id,  :default => nil
      t.datetime  :deleted_at,              :default => nil
      t.integer   :created_by_id,           :null => false
      t.integer   :updated_by_id,           :default => nil
      t.integer   :deleted_by_id,           :default => nil

      t.timestamps
    end

    add_index :metadatum_fields, :allowed_values_list_id, :unique => false
  end

  def down
    remove_index :metadatum_fields, :allowed_values_list_id
    drop_table :metadatum_fields
  end
end
