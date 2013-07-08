require 'spec_helper'

describe V1::MetadataTemplate do
  let(:template) { FactoryGirl.build(:v1_metadata_template) }

  subject { template }

  describe "creates instance given valid attributes" do
    it { should respond_to(:name) }
    it { should respond_to(:description) }
    it { should respond_to(:created_by_id) }
    it { should respond_to(:updated_by_id) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end
  it "adds an entry to the metadata template table upon save" do
    expect { template.save }.to change(V1::MetadataTemplate, :count).by(1)
  end
  it { should be_valid }

  describe "requires a name" do
    before { template.name = ' ' }
    it { 
      should_not be_valid 
      should have(1).error_on(:name)
    }
    specify { template.save.should be false }
  end

  describe "name should be unique" do
    before do
      dup_template = FactoryGirl.create(:v1_metadata_template)
      template.name = dup_template.name
    end   
    it { 
      should_not be_valid 
      should have(1).error_on(:name)
    }      
    specify { template.save.should be false }
  end

  describe "does not require a description" do
    before { template.description = '' }
    it { should be_valid }   
    specify { template.save.should be true } 
  end

  it_should_behave_like "an auditable model"
  it_should_behave_like "a model with timestamps"

  describe "deleting a template" do
    before { template.save }
    it "removes an template from the template table" do
      expect { template.destroy }.to change(V1::MetadataTemplate, :count).by(-1)
    end
  end
end
