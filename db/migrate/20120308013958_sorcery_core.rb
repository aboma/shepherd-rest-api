class SorceryCore < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      #t.string :username,         :null => false  # if you use another field as a username, for example email, you can safely remove this field.
      t.string :email,            :null => false   # if you use this field as a username, you might want to make it :null => false.
      t.string :crypted_password, :null => false
      t.string :salt,             :default => nil
      t.string :last_name,        :default => nil
      t.string :first_name,       :default => nil
      
      t.timestamps
    end
    
    add_index :users, :email, unique: true
    
  end

  def self.down
    drop_table :users
  end
end