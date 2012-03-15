require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :email => 'mgaborik@gmail.com', :last_name => 'Gaborik', :first_name => 'Marian', :password => 'letme1nb' }
  end
  
  it "should create a new instance given valid attributes" do
    valid_user = User.new(@attr)
    valid_user.should be_valid
  end
  
  it "should require an email" do
    no_email_user = User.new(@attr.merge(:email => ' '))
    no_email_user.should_not be_valid
  end
  
  it "should require email to be unique" do
    
  end
  
  it "should accept valid email addresses" do
    
  end
  
  it "should reject invalid email addresses" do
    
  end
  
  it "should require password to be at least 8 characters" do
    short_pw_user = User.new(@attr.merge(:password => "a" * 7))
    short_pw_user.should_not be_valid
  end
end
