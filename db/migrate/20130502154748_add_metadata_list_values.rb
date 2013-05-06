class AddMetadataListValues < ActiveRecord::Migration
  def up
    create_table :metadata_values do |t|
      t.string    :value,            :null => false
      t.string    :description,      :default => nil
      t.datetime  :deleted_at,       :default => nil
      t.integer   :created_by_id,    :null => false
      t.integer   :updated_by_id,    :default => nil
      t.integer   :deleted_by_id,    :default => nil
      
      t.timestamps
    end
  end

  def down
    drop_table :metadata_values
  end
end
