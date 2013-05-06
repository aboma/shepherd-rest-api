require 'spec_helper'

describe V1::MetadataValuesList do
  let(:values_list) { FactoryGirl.build(:v1_values_list) }
  
  subject { values_list }
  
  describe "creates instance given valid attributes" do
    it { should respond_to(:name) }
    it { should respond_to(:description) }
    it { should respond_to(:created_by_id) }
    it { should respond_to(:updated_by_id) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end
  it "adds an entry to the metadata values list table upon save" do
    expect { values_list.save }.to change(V1::MetadataValuesList, :count).by(1)
  end
  it { should be_valid }
  
  describe "requires a name" do
    before { values_list.name = ' ' }
    it { 
      should_not be_valid 
      should have(1).error_on(:name)
    }
    specify { values_list.save.should be false }
  end
  
  describe "name should be unique" do
    before do
      dup_values_list = FactoryGirl.create(:v1_values_list)
      values_list.name = dup_values_list.name
    end   
    it { 
      should_not be_valid 
      should have(1).error_on(:name)
    }      
    specify { values_list.save.should be false }
  end 
    
  #describe "has values through relationship" do
  #  it { should have_many(:values).through(:relationships) }
  #end
  
  it_should_behave_like "an auditable model"
  
  describe "has many values" do
    pending
  end
  
  describe "timestamps" do
    describe "saves a created by date" do
      before { values_list.save }
      specify { values_list.created_at.should be_present }
    end
    
    describe "saves an updated by date" do
      before { values_list.save }
      specify { values_list.updated_at.should be_present }
    end
  end
end