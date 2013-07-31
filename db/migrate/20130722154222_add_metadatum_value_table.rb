class AddMetadatumValueTable < ActiveRecord::Migration
  def up
    create_table :metadatum_values do |t|
      t.integer     :asset_id,              :null => false
      t.integer     :metadatum_field_id,    :null => false
      t.string      :metadatum_value,       :null => false
      t.integer     :created_by_id,         :null => false
      t.integer     :updated_by_id,         :default => nil
      t.integer     :deleted_by_id,         :default => nil

      t.timestamps
    end
    add_index :metadatum_values, :asset_id, :unique => false
    add_index :metadatum_values, :metadatum_field_id, :unique => false
  end

  def down
    remove_index :metadatum_values, :asset_id
    remove_index :metadatum_values, :metadatum_field_id
    drop_table :metadatum_values
  end
end
