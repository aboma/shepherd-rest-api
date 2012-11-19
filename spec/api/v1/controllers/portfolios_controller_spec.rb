require 'spec_helper'

describe V1::PortfoliosController, :type => :controller do
  #login_user   # create and login a new user before each test
  
  before do
    @portfolio_attrs = { :name => "rspec test portfolio" }
    @user = FactoryGirl.create(:user)
    sign_in @user
    @auth_token = @user.authentication_token
  end
    
  describe "unauthorized user" do
    let(:url) { "/portfolios" }
  
    it "should return 406 unacceptable for HTML request" do
      get :index
      response.status.should == 406
    end    
       
    it "should return 401 unauthorized code for JSON request" do
      get :index, nil, { 'HTTP_ACCEPT' => 'application/json' }
      response.status.should == 401
    end    
  end
    
  describe "POST to create portfolio" do
    it "should change number of portfolios by 1" do   
      expect{ post_portfolios }.to change(Portfolio, :count).by(1)
      #post_portfolios.should change(Portfolio, :count).by(1)
      response.should be_success
    end
     
    def post_portfolios
      post :create, :portfolio => @portfolio_attrs, 
        :headers => { 'CONTENT_TYPE' => 'application/json', 'X-AUTH-TOKEN' => @auth_token }
    end    
  end
    
#  describe "portfolios listed for user" do
#    let(:url) { "/portfolios" }
#    let(:expected) {{ :portfolios => { :id => 1 }}}.to_json
     
#    it "should return a list of portfolios" do
#      get "#{url}", nil, { 'HTTP_ACCEPT' => 'application/json' }
#      last_response.status.should be 200
#      parsed = JSON.parse(last_response.body)
#      parsed.should == expected
#    end
#  end
    

end