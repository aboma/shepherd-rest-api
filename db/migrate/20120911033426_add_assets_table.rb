class AddAssetsTable < ActiveRecord::Migration
  def up
    create_table :assets do |t|
      t.string    :name,             :null => false
      t.string    :file,             :null => false
      t.string    :content_type,     :null => false
      t.string    :size,             :null => false
      t.string    :description,      :default => nil
      t.datetime  :deleted_at,       :default => nil
      t.integer   :created_by_id,    :null => false
      t.integer   :updated_by_id,    :default => nil
      t.integer   :deleted_by_id,    :default => nil

      t.timestamps
    end  
  end

  def down
    drop_table :assets
  end
end
