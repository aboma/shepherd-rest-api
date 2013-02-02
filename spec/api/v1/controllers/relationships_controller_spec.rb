require 'spec_helper'

describe V1::RelationshipsController, :type => :controller do
  
  # get a valid authorization to use on requests
  get_auth_token
  
    # global helper methods
  def create_portfolio 
    @port = FactoryGirl.create(:portfolio) 
  end
  
  ### GET INDEX ==================================================
  describe "GET index" do 
    #shared example
    it_should_behave_like "a protected action" do
      def action(args_hash)
        get :index, :format => args_hash[:format]
      end      
    end
    
    it_should_behave_like "JSON controller index action"
  end  
end