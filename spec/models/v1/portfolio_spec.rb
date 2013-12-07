require 'spec_helper'

describe V1::Portfolio do
  let(:portfolio) { FactoryGirl.build(:v1_portfolio) }

  subject { portfolio }

  describe 'creates instance given valid attributes' do
    it { should respond_to(:name) }
    it { should respond_to(:description) }
    it { should respond_to(:metadata_template) }
    it { should respond_to(:created_by_id) }
    it { should respond_to(:updated_by_id) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
    it 'adds a portfolio to the portfolio table upon save' do
      expect { portfolio.save }.to change(V1::Portfolio, :count).by(1)
    end
    it { should be_valid }
  end

  describe 'requires a name' do
    before { portfolio.name = ' ' }
    it { should_not be_valid }
    it { should have(1).error_on(:name) }
    specify { portfolio.save.should be false }
  end

  describe 'name is unique' do
    before do
      portfolio_with_same_name = portfolio.dup
      portfolio_with_same_name.name = portfolio.name
      portfolio_with_same_name.save
    end   
    it { should_not be_valid }
    it { should have(1).error_on(:name) }
    specify { portfolio.save.should be false }
  end

  describe 'does not require a description' do
    before { portfolio.description = '' }
    it { should be_valid }   
    specify { portfolio.save.should be true } 
  end

  describe 'metadata template' do
    context 'is not required' do
      before { portfolio[:metadata_template_id] = nil }
      it { should be_valid }
      specify { portfolio.save.should be true }
    end
    context 'must be valid' do
      before { portfolio[:metadata_template_id] = 111111 }
      it { should_not be_valid }
      specify { portfolio.save.should be false }
    end
  end

  describe 'has assets through relationship' do
    it { should have_many(:assets).through(:relationships) }
  end

  it_should_behave_like 'an auditable model'

  describe 'timestamps' do
    describe 'saves a created by date' do
      before { portfolio.save }
      specify { portfolio.created_at.should be_present }
    end

    describe 'saves an updated by date' do
      before { portfolio.save }
      specify { portfolio.updated_at.should be_present }
    end
  end

  describe 'updating a portfolio sets the updated_by date' do
    before do
      portfolio.save 
      portfolio.name = 'test updated time'
      @original_up_time = portfolio.updated_at
      portfolio.save
    end
    specify do
      portfolio.should be_valid
      portfolio.updated_at.should be_present 
      portfolio.updated_at.should_not be @original_up_time 
    end 
  end  
end 
