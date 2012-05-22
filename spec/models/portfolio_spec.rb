require 'spec_helper'

describe Portfolio do
  before do
    @portfolio = FactoryGirl.create(:portfolio)
  end
  
  subject { @portfolio }
  
  describe "should create instance given valid attributes" do
    it { should respond_to(:name) }
    it { should respond_to(:description) }
    it { should be_valid }
  end
  
  describe "should require a name" do
    before { @portfolio.name = ' ' }
    it { should_not be_valid }  
  end
  
  describe "name should be unique" do
    #TODO <<<
  end
  
  describe "should not require a description" do
    before { @portfolio.description = '' }
    it { should be_valid }    
  end
  
end 