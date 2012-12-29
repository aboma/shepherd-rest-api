require 'spec_helper'

describe V1::PortfoliosController, :type => :controller do
  
  # get a valid authorization to use on requests
  get_auth_token
  
  ### GET INDEX ==================================================
  describe "GET index" do   
    context "with invalid authorization token" do
      [:json, :xml, :html].each do |format| 
        it "should return 401 unauthorized code for #{format}" do
          request.env['X-AUTH-TOKEN'] = '1111'
          get :index, :format => format
          subject.status.should == 401     
        end
      end
    end
    
    context "without authorization token" do   
      [:json, :xml, :html].each do |format| 
        it "should return 401 unauthorized code for #{format}" do
          get :index, :format => format
          response.status.should == 401
        end     
      end
    end
    
    context "with valid authorization token" do
      def get_index format
          request.env['X-AUTH-TOKEN'] = @auth_token
          get :index, :format => format
      end
      [:xml, :html].each do |format| 
        it "should return 406 code for format #{format}" do
          get_index format
          response.status.should == 406  
        end
      end    
      it "should return 200 success code for json format" do
          get_index :json
          response.status.should == 200        
      end   
      it "should return list of portfolios in json format" do
        pending
      end   
    end 
  end
  
  ### GET SHOW ==========================================================
  describe "GET show" do   
    context "with invalid authorization token" do
      [:json, :xml, :html].each do |format| 
        it "should return 401 unauthorized code for #{format}" do
          @port = FactoryGirl.create(:portfolio)
          request.env['X-AUTH-TOKEN'] = '1111'
          get :show, :id => @port.id, :format => format
          response.status.should == 401     
        end
      end
    end
    
    context "without authorization token" do 
      [:json, :xml, :html].each do |format| 
        it "should return 401 unauthorized code for #{format}" do
          @port = FactoryGirl.create(:portfolio)
          get :show, :id => @port.id, :format => format
          response.status.should == 401
        end     
      end
    end
    
    context "with valid authorization token" do
      before :each do
        request.env['X-AUTH-TOKEN'] = @auth_token
        @port = FactoryGirl.create(:portfolio)
        get :show, :id => @port.id, :format => :json
        @parsed = JSON.parse(response.body)
      end
      it "responds with success 200 status code" do
        response.status.should == 200       
      end    
      it "responds with JSON format" do
        response.header['Content-Type'].should include 'application/json'
      end
      it "responds with the asked for portfolio" do
        @parsed['portfolio']['id'].should == @port.id
      end
      it "responds with the portfolio name" do
        @parsed['portfolio']['name'].should == @port.name
      end
    end 
  end
  
  ### POST CREATE ========================================================
  describe "POST create" do
    def post_portfolio attrs, format
      request.env['X-AUTH-TOKEN'] = @auth_token
      post :create, :portfolio => attrs, :format => format 
    end 
      
    context "without authorization token" do    
      [:json, :xml, :html].each do |format| 
        it "should return 401 unauthorized code for #{format}" do
          post :create, :portfolio => FactoryGirl.attributes_for(:portfolio), :format => format
          response.status.should == 401   
        end
      end
    end
    
    context "with invalid authorization token" do
      [:json, :xml, :html].each do |format| 
        it "should return 401 unauthorized code for #{format}" do
          request.env['X-AUTH-TOKEN'] = '1111'
          post :create, :portfolio => FactoryGirl.attributes_for(:portfolio), :format => format
          response.status.should == 401     
        end
      end
    end  
    
    context "with authorization token" do           
      context "with invalid attributes" do
        before :each do
          post_portfolio({ :inv_attr => "invalid port" }, :json)
        end
        it "response with 422 unprocessable entity" do
          response.status.should == 422
        end
      end
        
      context "with valid attributes" do
        it "increases number of portfolios by 1" do   
          expect{ 
            post_portfolio(FactoryGirl.attributes_for(:portfolio), :json)
          }.to change(Portfolio, :count).by(1)
        end    
        
        before :each do
           @port_attrs = FactoryGirl.attributes_for(:portfolio)
           post_portfolio(@port_attrs, :json)
        end         
        it "responds with success 200 status code" do
          response.status.should == 200       
        end       
        it "responds with JSON format" do
          response.header['Content-Type'].should include 'application/json'
        end
      end
    end
  end
  
### PUT UPDATE ========================================================
  describe "PUT update" do
    pending
  end
  
### DELETE ========================================================
  describe "DELETE" do
    pending
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