class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :validatable, :trackable,
         :token_authenticatable

  before_save :ensure_authentication_token
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :first_name, :last_name, :authentication_token, :password, :password_confirmation, :remember_me
  
  before_save { |user| user.email = email.downcase }
 
  validates :password, :presence => true, :confirmation => true, :length => { :minimum => 8 }, :on => :create
  validates :last_name, :presence => true
  validates :first_name, :presence => true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true, :format => { :with => VALID_EMAIL_REGEX }, :uniqueness => { :case_sensitive => false }

end
