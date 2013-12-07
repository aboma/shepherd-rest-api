require 'spec_helper'

describe V1::MetadataTemplateFieldSetting do
  let(:field) { FactoryGirl.create(:v1_metadatum_field) }
  let(:template) { FactoryGirl.create(:v1_metadata_template) }
  let(:template_field_setting) do
    attrs = { metadatum_field_id: field.id, metadata_template_id: template.id }
    FactoryGirl.build(:v1_template_field_setting, attrs) 
  end

  subject { template_field_setting }

  describe 'creates instance given valid attributes' do
    it { should respond_to(:metadatum_field_id) }
    it { should respond_to(:required) }
    it { should respond_to(:order) }
    it { should respond_to(:created_by_id) }
    it { should respond_to(:updated_by_id) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end
  it 'adds an entry to the metadata template field setting table upon save' do
    expect { template_field_setting.save }.to change(V1::MetadataTemplateFieldSetting, :count).by(1)
  end
  it { should be_valid }

  describe 'requires a field id' do
    before { template_field_setting.metadatum_field_id = nil }
    it do 
      should_not be_valid
      should have(1).error_on(:metadatum_field_id)
    end
    specify { template_field_setting.save.should be false }
  end

  describe 'requires a required setting' do
    before { template_field_setting.required = nil }
    it do 
      should_not be_valid
      should have(1).error_on(:required)
    end
    specify { template_field_setting.save.should be false }
  end

  describe 'requires an order' do
    before { template_field_setting.order = nil }
    it do
      should_not be_valid
      should have(1).error_on(:order)
    end
    specify { template_field_setting.save.should be false }
  end

  it_should_behave_like 'an auditable model'
  it_should_behave_like 'a model with timestamps'

  describe 'deleting a template field setting' do
    before { template_field_setting.save }
    it 'removes a template field setting from the table' do
      expect { template_field_setting.destroy }.to change(V1::MetadataTemplateFieldSetting, :count).by(-1)
    end
  end
end
