require 'spec_helper'

describe V1::User do
  before :each do
    @user = FactoryGirl.build(:v1_user)
  end
  
  subject { @user } 
  
  describe "should create a new instance given valid email, first name, last name and pw" do  
    it { should respond_to(:email) }
    it { should respond_to(:first_name) }
    it { should respond_to(:last_name) }
    it { should respond_to(:password) }
    it "should add a user to the user table upon save" do
      lambda { @user.save }.should change(V1::User, :count).by(1)
    end
    it { should be_valid }
  end
  
  describe "should prevent against mass assignment for protected fields" do
    protected_fields = %w[crypted_password remember_me_token salt]
    protected_fields.each do |field_name|
      it { should_not be_accessible field_name }
    end
  end
  
  describe "requires an email" do
    before { @user.email = ' ' }
    it { should_not be_valid }
    specify { @user.save.should be false }
  end
  
  describe "requires a first name" do
    before { @user.first_name = ' ' }
    it { should_not be_valid }
    specify { @user.save.should be false }
  end
  
  describe "requires a last name" do
    before { @user.last_name = ' ' }
    it {should_not be_valid }
    specify { @user.save.should be false }
  end
  
  describe "requires a password" do
    before { @user.password = @user.password_confirmation = ' ' }
    it { should_not be_valid }
    specify { @user.save.should be false }
  end
  
  describe "requires email to be unique" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
    specify { @user.save.should be false }
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
      specify { @user.save.should be false }
    end
  end
  
  describe "requires password to be at least 8 characters" do
    before { @user.password = "a" * 7 }
    it { should_not be_valid }
    specify { @user.save.should be false }
  end
  
  describe "requires that password match password_confirmation" do
    before { @user.password_confirmation = "doesnotmatch" }
    it { should_not be_valid }
    specify { @user.save.should be false }
  end
  
  describe "requires a created by user id" do
    before { @user.created_by_id = nil }
    it { should_not be_valid }
    specify { @user.save.should be false}
  end
  
  describe "requires an updated by user id" do
    before { @user.updated_by_id = nil }
    it { should_not be_valid }
    specify { @user.save.should be false }
  end
  
  describe "should save a created_at date" do
    before { @user.save }  
    specify { @user.created_at.should be_present } 
  end
  
  describe "should save an updated by date" do
    before do 
      @user.save 
      @user.email = 'up_time@test.com'
      @original_up_time = @user.updated_at
      @user.save
    end
    specify do
      @user.should be_valid 
      @user.updated_at.should be_present 
      @user.updated_at.should_not == @original_up_time 
    end 
  end
end
