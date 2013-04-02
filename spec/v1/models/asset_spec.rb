require 'spec_helper'

describe V1::Asset do
  let(:asset) { FactoryGirl.build(:v1_asset) }
   
  subject { asset } 
    
  describe "creates instance given valid attributes" do
    it { should respond_to(:name) }
    it { should respond_to(:file) }
    it { should respond_to(:relationships) }
    it { should respond_to(:portfolios) }
    it { should respond_to(:created_by_id) }
    it { should respond_to(:updated_by_id) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
    it { should be_valid }
    it "adds an asset to the asset table upon save" do
      expect { asset.save }.to change(V1::Asset, :count).by(1)
    end
    it { should be_valid }
  end
  
  describe "requires a name" do
    before { asset.name = ' ' }
    it { 
      should_not be_valid 
      should have(1).error_on(:name)
    }
    specify { asset.save.should be false }
  end
  
  describe "name should be unique" do
    before do
      dup_asset = FactoryGirl.create(:v1_asset)
      asset.name = dup_asset.name
    end   
    it { 
      should_not be_valid 
      should have(1).error_on(:name)
    }      
    specify { asset.save.should be false }
  end
  
  describe "does not require a description" do
    before { asset.description = '' }
    it { should be_valid }   
    specify { asset.save.should be true } 
  end
  
  describe "requires a created by user id" do
    before { asset.created_by_id = nil }
    it { should_not be_valid }
    specify { asset.save.should be false }
  end
  
  describe "requires an updated by user id" do
    before { asset.updated_by_id = nil }
    it { should_not be_valid }
    specify { asset.save.should be false }
  end
  
  describe "timestamps" do
    describe "save a created by date" do
      before { asset.save }
      specify { asset.created_at.should be_present }
    end
    
    describe "save an updated by date" do
      before { asset.save }
      specify { asset.updated_at.should be_present }
    end
  end
  
  describe "deleting an asset" do
    before { asset.save }
    it "removes an asset from the asset table" do
      expect { asset.destroy }.to change(V1::Asset, :count).by(-1)
    end
    before do
      asset.save
      portfolio = FactoryGirl.create(:v1_portfolio)
      relation = FactoryGirl.build(:v1_relationship)
      relation.portfolio_id = portfolio.id
      relation.asset_id = asset.id
      relation.save
    end
    it "removes any associated relationships" do
      expect { asset.destroy }.to change(V1::Relationship, :count).by(-1)      
    end
  end
end