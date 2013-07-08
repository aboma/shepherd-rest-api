require 'spec_helper'

describe V1::MetadataTemplateFieldSetting do
  let(:field) { FactoryGirl.create(:v1_metadata_field) }
  let(:template) { FactoryGirl.create(:v1_metadata_template) }
  let(:template_field_setting) do
    attrs = { :field_id => field.id, :metadata_template_id => template.id }
    FactoryGirl.build(:v1_template_field_setting, attrs) 
  end

  subject { template_field_setting }

  describe "creates instance given valid attributes" do
    it { should respond_to(:field_id) }
    it { should respond_to(:required) }
    it { should respond_to(:order) }
    it { should respond_to(:created_by_id) }
    it { should respond_to(:updated_by_id) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end
  it "adds an entry to the metadata template field setting table upon save" do
    expect { template_field_setting.save }.to change(V1::MetadataTemplateFieldSetting, :count).by(1)
  end
  it { should be_valid }

  describe "requires a field id" do
    before { template_field_setting.field_id = nil }
    it { 
      should_not be_valid
      should have(1).error_on(:field_id)
    }
    specify { template_field_setting.save.should be false }
  end

  describe "requires a required setting" do
    before { template_field_setting.required = nil }
    it { 
      should_not be_valid
      should have(1).error_on(:required)
    }
    specify { template_field_setting.save.should be false }
  end


  describe "requires an order" do
    before { template_field_setting.order = nil }
    it { 
      should_not be_valid
      should have(1).error_on(:order)
    }
    specify { template_field_setting.save.should be false }
  end

  it_should_behave_like "an auditable model"
  it_should_behave_like "a model with timestamps"

  describe "deleting a template" do
    before { template_field_setting.save }
    it "removes an template from the template table" do
      expect { template_field_setting.destroy }.to change(V1::MetadataTemplateFieldSetting, :count).by(-1)
    end
  end
end
