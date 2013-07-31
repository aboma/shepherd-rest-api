require 'spec_helper'

describe V1::MetadatumValue do
  let(:value) do 
    attrs = FactoryGirl.attributes_for(:v1_metadatum_value)
    attrs[:asset] = FactoryGirl.create(:v1_asset) 
    attrs[:metadatum_field] = FactoryGirl.create(:v1_metadata_field)
    FactoryGirl.build(:v1_metadatum_value, attrs)
  end

  subject { value }

  describe "creates instance given valid attributes" do
    it { should respond_to(:asset_id) }
    it { should respond_to(:metadatum_field_id) }
    it { should respond_to(:metadatum_value) }
    it { should respond_to(:created_by_id) }
    it { should respond_to(:updated_by_id) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end
  it "adds an entry to the metadatum value field" do
    expect { value.save }.to change(V1::MetadatumValue, :count).by(1)
  end
  it { should be_valid }

  describe "requires an asset" do
    before { value.asset = nil }
    it {
      should_not be_valid 
      should have(1).error_on(:asset)
    }
    specify { value.save.should be false }
  end

  describe "requires a valid asset" do
    before { value.asset_id = 99999 }
    it {
      should_not be_valid 
      should have(1).error_on(:asset)
    }
    specify { value.save.should be false }
  end


  describe "requires a field" do
    before { value.metadatum_field = nil }
    it {
      should_not be_valid 
      should have(1).error_on(:metadatum_field)
    }
    specify { value.save.should be false }
  end

  describe "requires a valid field id" do
    before { value.metadatum_field_id = 99999 }
    it {
      should_not be_valid 
      should have(1).error_on(:metadatum_field)
    }
    specify { value.save.should be false }
  end


  describe "requires a value" do
    before { value.metadatum_value = nil }
    it {
      should_not be_valid 
      should have(1).error_on(:metadatum_value)
    }
    specify { value.save.should be false }
  end

  it_should_behave_like "an auditable model"
  it_should_behave_like "a model with timestamps" 

end
