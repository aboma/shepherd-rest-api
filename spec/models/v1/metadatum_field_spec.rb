require 'spec_helper'

describe V1::MetadatumField do
  let(:field) { FactoryGirl.build(:v1_metadatum_field) }

  subject { field }

  describe "creates instance given valid attributes" do
    it { should respond_to(:name) }
    it { should respond_to(:description) }
    it { should respond_to(:type) }
    it { should respond_to(:allowed_values_list) }
    it { should respond_to(:created_by_id) }
    it { should respond_to(:updated_by_id) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end
  it "adds an entry to the metadata fields table upon save" do
    expect { field.save }.to change(V1::MetadatumField, :count).by(1)
  end
  it { should be_valid }

  describe "requires a name" do
    before { field.name = ' ' }
    it { should_not be_valid }
    it { should have(1).error_on(:name) }
    specify { field.save.should be false }
  end

  describe "name should be unique" do
    before do
      dup_field = FactoryGirl.create(:v1_metadatum_field)
      field.name = dup_field.name
    end   
    it { should_not be_valid }
    it { should have(1).error_on(:name) }   
    specify { field.save.should be false }
  end

  describe "requires a type" do
    before { field.type = ' ' }
    it { should_not be_valid }
    it { should have(1).error_on(:type) }
    specify { field.save.should be false }
  end

  describe "type must be in list (text, boolean, integer, date)" do
    context "value is in list" do
      before { field.type = 'boolean' }
      it { should be_valid }
      specify { field.save.should be true }
    end
    context "value is not in list" do
      before { field.type = 'bananas' }
      it { should_not be_valid }
      specify { field.save.should be false }
      specify { 
        field.save
        field.errors[:type].to_s.should =~ /.*bananas is not in list:.*/
      }
    end
  end

  describe "does not require a description" do
    before { field.description = '' }
    it { should be_valid }   
    specify { field.save.should be true } 
  end

  describe "belongs to an allowed values list" do
    it { should belong_to(:allowed_values_list) }
  end

  it_should_behave_like "an auditable model"
  it_should_behave_like "a model with timestamps"

  describe "deleting a field" do
    describe "without assocatiated template field setting" do
      before { field.save }
      it "removes an field from the field table" do
        expect { field.destroy }.to change(V1::MetadatumField, :count).by(-1)
      end
    end
    describe "with associated template field setting" do
      before :each do
        field.save
        # create template and field setting associated with this field
        template = FactoryGirl.create(:v1_metadata_template)
        attrs = FactoryGirl.attributes_for(:v1_template_field_setting)
        attrs[:metadata_template_id] = template.id
        attrs[:metadatum_field_id] = field.id
        FactoryGirl.create(:v1_template_field_setting, attrs)
      end
      it "raises exception" do
        expect { field.destroy }.to raise_error(ActiveRecord::DeleteRestrictionError)
      end
    end
  end

end
