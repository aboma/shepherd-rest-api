require 'spec_helper'

describe V1::MetadataTemplateFieldSettingsController, type: :controller do
  include LoginHelper

  let(:setting) { FactoryGirl.create(:v1_field_setting) }

  describe 'get INDEX' do
    it_should_behave_like 'a protected action' do
      def action(args_hash)
        get :index, format: args_hash[:format]
      end
    end

    context 'with valid authorization token' do
      it_should_behave_like 'JSON controller index action'
    end
  end
end
