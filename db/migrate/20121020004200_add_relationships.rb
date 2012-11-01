class AddRelationships < ActiveRecord::Migration
  def up
    create_table :relationships do |t|
      t.column :relationship_type, :string
      t.column :asset_id, :integer
      t.column :portfolio_id, :integer
      
      t.timestamps
    end
  end

  def down
    drop_table :relationships
  end
end
