require 'spec_helper'

describe V1::RelationshipsController, :type => :controller do
  include LoginHelper
  
  # get a valid authorization to use on requests
  before :all do
    create_test_user
  end
  
  after :all do
    destroy_test_user
  end
    
    # global helper methods
  def create_portfolio 
    @port = FactoryGirl.create(:v1_portfolio) 
  end
  
  ### GET INDEX ==================================================
  describe "get INDEX" do 
    it_should_behave_like "a protected action" do
      def action(args_hash)
        get :index, :format => args_hash[:format]
      end      
    end
    
    it_should_behave_like "JSON controller index action"
    
    describe "with a portfolio_id as a query parameter" do
      it "returns relationships filtered by portfolio id" do
        pending
      end
    end
  end
  
  ### GET SHOW ==========================================================
#  describe "get SHOW" do
#    it_should_behave_like "a protected action" do
#      let(:data) { { :portfolio_id => @port.id } }
#      def action(args_hash)
#        get :show, args_hash[:data], :format => args_hash[:format]
#      end      
#    end    
#  end
end