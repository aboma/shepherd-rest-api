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
#  created_at                   :datetime        not null
#  updated_at                   :datetime        not null
#  remember_me_token            :string(255)
#  remember_me_token_expires_at :datetime
#

require 'spec_helper'

describe User do
  before do
    @user = FactoryGirl.create(:user)
  end
  
  subject { @user } 
  
  describe "should create a new instance given valid attributes" do  
    it { should respond_to(:email) }
    it { should respond_to(:first_name) }
    it { should respond_to(:last_name) }
    it { should respond_to(:password) }
    it { should be_valid }
  end
  
  describe "should require an email" do
    before { @user.email = ' ' }
    it { should_not be_valid }
  end
  
  describe "should require a first name" do
    
  end
  
  describe "should require a first name" do
    
  end
  
  describe "should require email to be unique" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end
  
  describe "should accept valid email addresses" do
    
  end
  
  describe "should reject invalid email addresses" do
    invalid_emails =  %w[user@boom,com user_at_boo.org example.user@boo. user@boo user.boo@boo ]
    invalid_emails.each do |invalid_email|
      before { @user.email = invalid_email }
      it { should_not be_valid }
    end
  end
  
  describe "should require password to be at least 8 characters" do
    before { @user.password = "a" * 7 }
    it { should_not be_valid }
  end
  
  describe "should require that password match password_confirmation" do
    
  end
end
