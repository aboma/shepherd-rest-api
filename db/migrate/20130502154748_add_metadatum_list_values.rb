class AddMetadatumListValues < ActiveRecord::Migration
  def up
    create_table :metadatum_list_values do |t|
      t.string    :value,                   :null => false
      t.string    :description,             :default => nil
      t.integer   :metadatum_values_list_id, :null => :false
      t.datetime  :deleted_at,              :default => nil
      t.integer   :created_by_id,           :null => false
      t.integer   :updated_by_id,           :default => nil
      t.integer   :deleted_by_id,           :default => nil

      t.timestamps
    end
    add_index :metadatum_list_values, :metadatum_values_list_id, :unique => false
  end

  def down
    remove_index :metadatum_list_values, :metadatum_values_list_id
    drop_table :metadatum_list_values
  end
end
