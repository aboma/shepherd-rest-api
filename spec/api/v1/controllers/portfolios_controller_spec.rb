require 'spec_helper'

describe V1::PortfoliosController, :type => :controller do
  
  get_auth_token
  
  describe "GET index" do
    context "without authorization token" do   
      it "should return 401 unauthorized code" do
        get :index, :format => :html
        response.status.should == 401
      end    
         
      it "should return 401 unauthorized code" do
        get :index, :format => :json
        response.status.should == 401
      end    
    end
    
    context "with invalid authorization token" do
      it "should return 401 unauthorized code" do
        request.env['X-AUTH-TOKEN'] = '1111'
        get :index, :format => :json
        response.status.should == 401     
      end
    end
  end
   
  describe "POST create" do
    
    context "without authorization token" do     
      it "should return 401 unauthorized HTTP code" do
        post :create, :portfolio => FactoryGirl.attributes_for(:portfolio), :format => :json
        response.status.should == 401   
      end
      it "should return content of JSON type" do
        post :create, :portfolio => FactoryGirl.attributes_for(:portfolio), :format => :json
        #debugger
        response.headers['Content-Type'].should include 'application/json'
      end
    end
    
    context "with authorization token" do
      def post_portfolio attrs, format
        request.env['X-AUTH-TOKEN'] = @auth_token
        post :create, :portfolio => attrs, :format => format 
      end   
            
      context "with invalid attributes" do
        pending
      end
        
      context "with valid attributes" do
        it "should change number of portfolios by 1" do   
          expect{ 
            post_portfolio(FactoryGirl.attributes_for(:portfolio), :json)
          }.to change(Portfolio, :count).by(1)
        end    
          
        it "responds with success" do
          post_portfolio(FactoryGirl.attributes_for(:portfolio), :json)
          response.header['Content-Type'].should include 'application/json'
          response.status.should == 200       
        end
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