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
  before :each do
    @user = FactoryGirl.build(:user)
  end
  
  subject { @user } 
  
  describe "should create a new instance given valid email, first name, last name and pw" do  
    it { should respond_to(:email) }
    it { should respond_to(:first_name) }
    it { should respond_to(:last_name) }
    it { should respond_to(:password) }
    it "should add a user to the user table upon save" do
      lambda { @user.save }.should change(User, :count).by(1)
    end
    it { should be_valid }
  end
  
  describe "should prevent against mass assignment for protected fields" do
    protected_fields = %w[crypted_password remember_me_token salt]
    protected_fields.each do |field_name|
      it { should_not be_accessible field_name }
    end
  end
  
  describe "should require an email" do
    before { @user.email = ' ' }
    it { should_not be_valid }
    specify { @user.save.should == false }
  end
  
  describe "should require a first name" do
    before { @user.first_name = ' ' }
    it { should_not be_valid }
    specify { @user.save.should == false }
  end
  
  describe "should require a last name" do
    before { @user.last_name = ' ' }
    it {should_not be_valid }
    specify { @user.save.should == false }
  end
  
  describe "should require a password" do
    before { @user.password = @user.password_confirmation = ' ' }
    it { should_not be_valid }
    specify { @user.save.should == false }
  end
  
  describe "should require email to be unique" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
    specify { @user.save.should == false }
  end
  
  describe "should accept valid email addresses" do
    valid_emails = %w[user@gmail.com user.us@bbc.co.uk user-us@co.com]
    valid_emails.each do |valid_email|
      before { @user.email = valid_email }
      it { should be_valid }
    end
  end
  
  describe "should reject invalid email addresses" do
    invalid_emails =  %w[john@box@host.net .user_at_me.org user@boom. john@-host.ne user@boom user.boom@boom ]
    invalid_emails.each do |invalid_email|
      before { @user.email = invalid_email }
      it { should_not be_valid }
      specify { @user.save.should == false }
    end
  end
  
  describe "should require password to be at least 8 characters" do
    before { @user.password = "a" * 7 }
    it { should_not be_valid }
    specify { @user.save.should == false }
  end
  
  describe "should require that password match password_confirmation" do
    before { @user.password_confirmation = "doesnotmatch" }
    it { should_not be_valid }
    specify { @user.save.should == false }
  end
end
