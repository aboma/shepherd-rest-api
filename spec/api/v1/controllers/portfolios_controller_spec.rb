require 'spec_helper'

describe V1::PortfoliosController, :type => :controller do
  
  before :each do
    @portfolio_attrs = { :name => 'rspec test port' }
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = FactoryGirl.create(:user)
    sign_in user
    user.reset_authentication_token!
    @auth_token = user.authentication_token
  end
  
  describe "unauthorized user" do
    let(:url) { "/portfolios" }
  
    it "should return 406 unacceptable for HTML request without token" do
      get :index
      response.status.should == 406
    end    
       
    it "should return 401 unauthorized code for JSON request without token" do
      get :index, nil, { 'CONTENT-TYPE' => 'application/json' }
      response.status.should == 401
    end    
    
    it "should return 401 unauthorized code for JSON request with invalid token" do
      get :index, nil, { 'CONTENT-TYPE' => 'application/json', 'X-AUTH-TOKEN' => '111111' }
      response.status.should == 401     
    end
  end
   
  describe "authorized user" do
    
    describe "POST to create portfolio" do
      it "should change number of portfolios by 1" do   
        expect{ 
          post :create, :portfolio => @portfolio_attrs, 
            :headers => { 'CONTENT-TYPE' => 'application/json', 'X-AUTH-TOKEN' => @auth_token }
           }.to change(Portfolio, :count).by(1)
        #post_portfolios.should change(Portfolio, :count).by(1)
      end
       
      def post_portfolios
        #debugger

      end    
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