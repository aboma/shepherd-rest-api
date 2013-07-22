class AddMetadataListValues < ActiveRecord::Migration
  def up
    create_table :metadata_list_values do |t|
      t.string    :value,                   :null => false
      t.string    :description,             :default => nil
      t.integer   :metadata_values_list_id, :null => :false
      t.datetime  :deleted_at,              :default => nil
      t.integer   :created_by_id,           :null => false
      t.integer   :updated_by_id,           :default => nil
      t.integer   :deleted_by_id,           :default => nil

      t.timestamps
    end
    add_index :metadata_list_values, :metadata_values_list_id, :unique => false
  end

  def down
    remove_index :metadata_list_values, :metadata_values_lis_id
    drop_table :metadata_list_values
  end
end
