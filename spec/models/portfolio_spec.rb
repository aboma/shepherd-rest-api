require 'spec_helper'

describe Portfolio do
  before do
    @portfolio = FactoryGirl.build(:portfolio)
  end
  
  subject { @portfolio }
  
  describe "should create instance given valid attributes" do
    it { should respond_to(:name) }
    it { should respond_to(:description) }
    it { should be_valid }
    specify { @portfolio.save.should == true }
  end
  
  describe "should require a name" do
    before { @portfolio.name = ' ' }
    it { should_not be_valid }  
    specify { @portfolio.save.should == false }
  end
  
  describe "name should be unique" do
    before do
      portfolio_with_same_name = @portfolio.dup
      portfolio_with_same_name.name = @portfolio.name
      portfolio_with_same_name.save
    end   
    it { should_not be_valid }
    specify { @portfolio.save.should == false }
  end
  
  describe "should not require a description" do
    before { @portfolio.description = '' }
    it { should be_valid }   
    specify { @portfolio.save.should == true } 
  end
  
end 