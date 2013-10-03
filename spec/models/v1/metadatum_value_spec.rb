require 'spec_helper'

describe V1::MetadatumValue do
  def metadatum_of_type(type)   
    attrs = FactoryGirl.attributes_for(:v1_metadatum_value)
    attrs[:asset] = FactoryGirl.create(:v1_asset) 
    type = :text if !type 
    attrs[:metadatum_field] = FactoryGirl.create(:v1_metadatum_field, { :type => type })
    return FactoryGirl.build(:v1_metadatum_value, attrs)
  end

  let(:value) do 
    attrs = FactoryGirl.attributes_for(:v1_metadatum_value)
    attrs[:asset] = FactoryGirl.create(:v1_asset) 
    attrs[:metadatum_field] = FactoryGirl.create(:v1_metadatum_field)
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


  describe "requires a metadatum value" do
    before { value.metadatum_value = nil }
    it {
      should_not be_valid 
      should have(1).error_on(:metadatum_value)
    }
    specify { value.save.should be false }
  end

  describe "validates metadatum value" do
    context "boolean field" do
      let(:metadatum) { metadatum_of_type(:boolean) }
      context "valid boolean" do
        it "will save" do
          valid_booleans = [ "f", "0", "1", "true", "TRUE", "false", "FALSE" ]
          valid_booleans.each do |valid_bool|
            metadatum.metadatum_value = valid_bool
            metadatum.save.should be true
          end
        end
      end
      context "invalid boolean" do
        it "will not save" do
          invalid_booleans = [ "nil", "falsey", "tru", '2' ]
          invalid_booleans.each do |invalid_bool|
            metadatum.metadatum_value = invalid_bool
            metadatum.save.should be false
            metadatum.should have(1).error_on(:metadatum_value)
          end
        end
      end
    end
    context "integer field" do
      let(:metadatum) { metadatum_of_type(:integer) }
      context "valid integer" do
        it "will save" do
          valid_integers = [ "0", "1", "-1", "89192" ]
          valid_integers.each do |valid_int|
            metadatum.metadatum_value = valid_int
            metadatum.save.should be true
          end
        end
      end
      context "invalid integer" do
        it "will not save" do
          invalid_integers = [ 'notint', '1.1', '0.1', 'true' ]
          invalid_integers.each do |invalid_int|
            metadatum.metadatum_value = invalid_int
            metadatum.save.should be false
            metadatum.should have(1).error_on(:metadatum_value)
          end
        end
      end
    end
  end

  it_should_behave_like "an auditable model"
  it_should_behave_like "a model with timestamps" 

end
