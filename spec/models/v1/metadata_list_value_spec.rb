require 'spec_helper'

describe V1::MetadatumListValue do
  let(:list)  { FactoryGirl.create(:v1_values_list) }
  let(:value) { FactoryGirl.build(:v1_value, { metadatum_values_list_id: list.id }) }

  subject { value }

  describe "creates instance given valid attributes" do
    it { should respond_to(:value) }
    it { should respond_to(:description) }
    it { should respond_to(:created_by_id) }
    it { should respond_to(:updated_by_id) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end
  it "adds an entry to the metadata list values table upon save" do
    expect { value.save }.to change(V1::MetadatumListValue, :count).by(1)
  end
  it { should be_valid }

  describe "requires a value" do
    before { value.value = ' ' }
    it do 
      should_not be_valid 
      should have(1).error_on(:value)
    end
    specify { value.save.should be false }
  end

  describe "does not require a description" do
    before { value.description = '' }
    it { should be_valid }   
    specify { value.save.should be true } 
  end

  describe "requires a metadata list id" do
    before { value.metadatum_values_list_id = nil }
    it { should_not be_valid }
    specify { value.save.should be false }
  end

  it_should_behave_like "an auditable model"

end
