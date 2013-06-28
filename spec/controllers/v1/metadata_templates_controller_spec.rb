require 'spec_helper'

describe V1::MetadataTemplatesController, :type => :controller do
  include LoginHelper

  before :all do 
    create_test_user
  end

  after :all do
    destroy_test_user
  end

  let(:template) { FactoryGirl.create(:v1_metadata_template) }

  describe "get INDEX" do
    it_should_behave_like "a protected action" do
      def action(args_hash)
        get :index, :format => args_hash[:format]
      end
    end

    context "with valid authorization token" do
      it_should_behave_like "JSON controller index action"
    end
  end
end
