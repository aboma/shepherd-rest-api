class User < ActiveRecord::Base
  authenticates_with_sorcery!
   
  attr_accessible :email, :password, :password_confirmation, :last_name, :first_name

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email, :last_name, :first_name
  validates_uniqueness_of :email
end
