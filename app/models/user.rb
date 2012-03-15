# == Schema Information
#
# Table name: users
#
#  id                           :integer         not null, primary key
#  email                        :string(255)
#  crypted_password             :string(255)
#  salt                         :string(255)
#  last_name                    :string(255)
#  first_name                   :string(255)
#  created_at                   :datetime
#  updated_at                   :datetime
#  remember_me_token            :string(255)
#  remember_me_token_expires_at :datetime
#

class User < ActiveRecord::Base
  authenticates_with_sorcery!
   
  attr_accessible :email, :password, :password_confirmation, :last_name, :first_name

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email, :last_name, :first_name
  validates_uniqueness_of :email
end
