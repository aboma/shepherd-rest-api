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
    FactoryGirl.create(:v1_portfolio) 
  end
  
  def create_asset
    FactoryGirl.create(:v1_asset)
  end
  
  ### GET INDEX ==================================================
  describe "get INDEX" do
    it_should_behave_like "a protected action" do
      def action(args_hash)
        get :index, :format => args_hash[:format]
      end
    end
    
    context "with valid authorization token" do
      it_should_behave_like "JSON controller index action"
      context "given portfolio id" do
        if "should return assets for that portfolio"
          pending
        end
      end
    end
  end
  
  ### GET SHOW ===================================================
  describe "get SHOW" do
    let(:asset) { create_asset }
    
    context "unauthorized user" do
      it_should_behave_like "a protected action" do
        let(:data) { { :id => asset.id } }
        def action(args_hash)
          get :show, args_hash[:data], :format => args_hash[:format]
        end      
      end
    end
    context "with valid authorization token" do
      context "valid asset id" do
        before :each do
          create_asset
          request.env['X-AUTH-TOKEN'] = @auth_token
          get :show, :id => asset.id, :format => :json
          @parsed = JSON.parse(response.body)
        end
        it_should_behave_like "an action that responds with JSON"
        it "responds with the asked for asset" do
          @parsed['asset']['id'].should == asset.id
        end 
      end
      context "invalid asset id" do
        before :each do
          request.env['X-AUTH-TOKEN'] = @auth_token
          get :show, :id => asset.id + 111, :format => :json
          @parsed = JSON.parse(response.body)
        end
        it_should_behave_like "an action that responds with JSON"
        it "responds with 404 not found" do
          response.status.should == 404
        end      
      end 
    end
  end
  
    ### POST CREATE ========================================================
  describe "post CREATE" do
    it_should_behave_like "a protected action" do
      let(:data) { FactoryGirl.attributes_for(:v1_asset) }
      def action(args_hash)
        post :create, :asset => args_hash[:data], :format => args_hash[:format] 
      end   
    end
           
    context "with valid authorization token" do 
      def post_asset attrs, format
        request.env['X-AUTH-TOKEN'] = @auth_token
        post :create, :asset => attrs, :format => format 
      end  
      context "with XML or HTML format" do
        [:xml, :html].each do |format|
          before :each do
            post_asset(FactoryGirl.attributes_for(:v1_asset), format)          
          end
          it "should return 406 code for format #{format}" do
            response.status.should == 406  
          end
          it "does not create the asset" do
            expect{ 
              post_asset(FactoryGirl.attributes_for(:v1_asset), format)
            }.to_not change(V1::Asset, :count)
          end
        end          
      end    
      context "with JSON format" do    
        context "with invalid attributes" do
          pending
        end
        context "missing required attributes" do
          let(:valid_attrs) { FactoryGirl.attributes_for(:v1_asset) }
          let(:invalid_attrs) { 
            valid_attrs.delete(:name)
            valid_attrs
          }
          it "does not create an asset" do
            expect{ 
              post_asset(invalid_attrs, :json)
            }.to_not change(V1::Asset, :count)
          end
          #subject {}
          it "responds with 422 unprocessable entity" do
            post_asset(invalid_attrs, :json)
            response.status.should == 422
          end
        end
        
        context "with valid attributes" do
          it "creates one asset" do   
            expect{ 
              post_asset(FactoryGirl.attributes_for(:v1_asset), :json)
            }.to change(V1::Asset, :count).by(1)
          end 
          before :each do
            post_asset(FactoryGirl.attributes_for(:v1_asset), :json)
          end
          it_should_behave_like "an action that responds with JSON"       
          it "responds with success 200 status code" do
            response.status.should == 200       
          end
          it "responds with Location header" do
            response.header['Location'].should be_present
          end
        end
      end
    end
  end
end