# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  last_name              :string(255)
#  first_name             :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  authentication_token   :string(255)
#  created_by_id          :integer          not null
#  updated_by_id          :integer
#  deleted_by_id          :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

module V1
  class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :token_authenticatable, :confirmable,
    # :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, 
           :recoverable, :validatable, :trackable,
           :token_authenticatable
  
    before_save :ensure_authentication_token
    
    # Setup accessible (or protected) attributes for your model
    attr_accessible :email, :first_name, :last_name, :authentication_token, :password, 
                    :password_confirmation, :remember_me, :created_by_id, :updated_by_id
    
    before_save { |user| user.email = email.downcase }
   
    validates :password, :presence => true, :confirmation => true, :length => { :minimum => 8 }, :on => :create
    validates :last_name, :presence => true
    validates :first_name, :presence => true
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, :presence => true, :format => { :with => VALID_EMAIL_REGEX }, :uniqueness => { :case_sensitive => false }
    validates :created_by_id, :presence => true
    validates :updated_by_id, :presence => true
  end
end
