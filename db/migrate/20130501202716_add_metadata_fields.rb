class AddMetadataFields < ActiveRecord::Migration
  def up
    create_table :metadata_fields do |t|
      t.string    :name,             :null => :false
      t.string    :description,      :null => :false
      t.string    :type,             :null => :false
      t.string    :values_list_name, :default => nil
      t.datetime  :deleted_at,       :default => nil
      t.integer   :created_by_id,    :null => false
      t.integer   :updated_by_id,    :default => nil
      t.integer   :deleted_by_id,    :default => nil
      
      t.timestamps
    end
  end

  def down
    drop_table :metadata_fields
  end
end
