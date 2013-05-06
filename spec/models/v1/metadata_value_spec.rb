require 'spec_helper'

describe V1::MetadataValue do
  let(:value) { FactoryGirl.build(:v1_value) }

  subject { value }

  describe "creates instance given valid attributes" do
    it { should respond_to(:value) }
    it { should respond_to(:description) }
    it { should respond_to(:created_by_id) }
    it { should respond_to(:updated_by_id) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end
  it "adds an entry to the metadata values table upon save" do
    expect { value.save }.to change(V1::MetadataValue, :count).by(1)
  end
  it { should be_valid }

  describe "requires a value" do
    before { value.value = ' ' }
    it { 
      should_not be_valid 
      should have(1).error_on(:value)
    }
    specify { value.save.should be false }
  end

  describe "value should be unique" do
    before do
      dup_value = FactoryGirl.create(:v1_value)
      value.value = dup_value.value
    end   
    it { 
      should_not be_valid 
      should have(1).error_on(:value)
    }      
    specify { value.save.should be false }
  end

  describe "does not require a description" do
    before { value.description = '' }
    it { should be_valid }   
    specify { value.save.should be true } 
  end
end
