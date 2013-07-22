class AddRelationships < ActiveRecord::Migration
  def up
    create_table :relationships do |t|
      t.integer   :asset_id,          :null => false
      t.integer   :portfolio_id,      :null => false
      t.datetime  :deleted_at,        :default => nil
      t.integer   :created_by_id,     :null => false
      t.integer   :updated_by_id,     :default => nil
      t.integer   :deleted_by_id,     :default => nil

      t.timestamps
    end

    add_index :relationships, :asset_id, :unique => false 
    add_index :relationships, :portfolio_id, :unique => false 
  end

  def down
    remove_index :relationships, :asset_id
    remove_index :relationships, :portfolio_id
    drop_table :relationships
  end
end
