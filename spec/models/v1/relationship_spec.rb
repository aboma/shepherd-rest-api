require 'spec_helper'

describe V1::Relationship do
  let(:asset) { FactoryGirl.create(:v1_asset) }
  let(:portfolio) { FactoryGirl.create(:v1_portfolio) }
  let(:relation) { FactoryGirl.build(:v1_relationship, \
     { :portfolio_id => portfolio.id, :asset_id => asset.id }) }
  
  subject { relation } 
    
  describe "creates instance given valid attributes" do
    it { should respond_to(:portfolio_id) }
    it { should respond_to(:asset_id) }
    it { should respond_to(:created_by_id) }
    it { should respond_to(:updated_by_id) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
    it { should be_valid }
    it "adds an asset to the asset table upon save" do
      expect { relation.save }.to change(V1::Relationship, :count).by(1)
    end
    it { should be_valid }
  end
  
  describe "requires a portfolio id" do
    before { relation.portfolio_id = nil }
    it { 
      should_not be_valid 
      should have(1).error_on(:portfolio)
    }
    specify { relation.save.should be false }
  end
  
  describe "requires an asset id" do
    before { relation.asset_id = nil }
    it { 
      should_not be_valid 
      should have(1).error_on(:asset)
    }
    specify { relation.save.should be false }
  end
  
  describe "requires valid portfolio id" do
    before { relation.portfolio_id = 99999 }
    it { 
      should_not be_valid 
      should have(1).error_on(:portfolio)
    }
    specify { relation.save.should be false }    
  end
  
  describe "requires valid asset id" do
    before { relation.asset_id = 99999 }
    it { 
      should_not be_valid 
      should have(1).error_on(:asset)
    }
    specify { relation.save.should be false }    
  end
    
  it_should_behave_like "an auditable model"
  
  describe "timestamps" do
    describe "save a created by date" do
      before { relation.save }
      specify { relation.created_at.should be_present }
    end
    
    describe "save an updated by date" do
      before { relation.save }
      specify { relation.updated_at.should be_present }
    end
  end
  
end
