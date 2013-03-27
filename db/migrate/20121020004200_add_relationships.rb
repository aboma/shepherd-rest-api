class AddRelationships < ActiveRecord::Migration
  def up
    create_table :relationships do |t|
      t.column :relationship_type, :string
      t.column :asset_id, :integer
      t.column :portfolio_id, :integer
      t.datetime  :deleted_at,       :default => nil
      t.integer   :created_by_id,    :null => false
      t.integer   :updated_by_id,    :default => nil
      t.integer   :deleted_by_id,    :default => nil
      
      t.timestamps
    end
  end

  def down
    drop_table :relationships
  end
end
