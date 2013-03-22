require 'spec_helper'

describe V1::Portfolio do
  before :each do
    @portfolio = FactoryGirl.build(:v1_portfolio)
  end
  
  subject { @portfolio }
  
  describe "should create instance given valid attributes" do
    it { should respond_to(:name) }
    it { should respond_to(:description) }
    it { should be_valid }
    it "should add a portfolio to the portfolio table upon save" do
      lambda { @portfolio.save }.should change(V1::Portfolio, :count).by(1)
    end
    it { should be_valid }
  end
  
  describe "should require a name" do
    before { @portfolio.name = ' ' }
    it { 
      should_not be_valid 
      should have(1).error_on(:name)
    }
    specify { @portfolio.save.should be false }
  end
  
  describe "name should be unique" do
    before do
      portfolio_with_same_name = @portfolio.dup
      portfolio_with_same_name.name = @portfolio.name
      portfolio_with_same_name.save
    end   
    it { 
      should_not be_valid 
      should have(1).error_on(:name)
    }      
    specify { @portfolio.save.should be false }
  end
  
  describe "should not require a description" do
    before { @portfolio.description = '' }
    it { should be_valid }   
    specify { @portfolio.save.should be true } 
  end
  
  describe "should require a created by user id" do
    before { @portfolio.created_by_id = nil }
    it { should_not be_valid }
    specify { @portfolio.save.should be false }
  end
  
  describe "should require an updated by user id" do
    before { @portfolio.updated_by_id = nil }
    it { should_not be_valid }
    specify { @portfolio.save.should be false }
  end
  
  describe "timestamps" do
    describe "should save a created by date" do
      before { @portfolio.save }
      specify { @portfolio.created_at.should be_present }
    end
    
    describe "should save an updated by date" do
      before { @portfolio.save }
      specify { @portfolio.updated_at.should be_present }
    end
  end
  
  describe "updating a portfolio should set the updated_by date" do
    before do
      @portfolio.save 
      @portfolio.name = 'test updated time'
      @original_up_time = @portfolio.updated_at
      @portfolio.save
    end
    specify do
      @portfolio.should be_valid
      @portfolio.updated_at.should be_present 
      @portfolio.updated_at.should_not be @original_up_time 
    end 
  end  
end 