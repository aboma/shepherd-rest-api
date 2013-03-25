require 'spec_helper'

describe V1::AssetsController, :type => :controller do
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
  
  describe "get INDEX" do
    
  end
  
end