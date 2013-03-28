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
  def create_relationship 
    FactoryGirl.create(:v1_relationship) 
  end
  
  def given_relation_attrs_with(options)
    attrs = FactoryGirl.attributes_for(:v1_relationship)
    attrs[:asset_id] = FactoryGirl.create(:v1_asset).id if options[:valid_asset]
    attrs[:asset_id] = '12345' unless options[:valid_asset]
    attrs[:portfolio_id] = FactoryGirl.create(:v1_portfolio).id if options[:valid_portfolio]
    attrs[:portfolio_id] = '12345' unless options[:valid_portfolio]
    yield attrs
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
  describe "get SHOW" do
    let(:relation) do
      given_relation_attrs_with({ :valid_asset => true, :valid_portfolio => true}) do |attrs|
        FactoryGirl.create(:v1_relationship, attrs)
      end
    end
    context "unauthorized user" do
      it_should_behave_like "a protected action" do
        let(:data) { { :id => relation.id } }
        def action(args_hash)
          get :show, args_hash[:data], :format => args_hash[:format]
        end      
      end 
    end
    
    context "with valid authorization token" do
      context "valid relationship id" do
        before :each do
          request.env['X-AUTH-TOKEN'] = @auth_token
          get :show, :id => relation.id, :format => :json
          @parsed = JSON.parse(response.body) 
        end
        it_should_behave_like "an action that responds with JSON"
        it "responds with success 200 status code" do
          response.status.should == 200       
        end
        it "responds with the asked for portfolio" do
          @parsed['relationship']['id'].should == relation.id
        end
      end
      context "valid asset and portfolio ids" do
        pending
      end
      context "invalid relationship id" do
        before :each do
          relation.id += 5
          request.env['X-AUTH-TOKEN'] = @auth_token
          get :show, :id => relation.id, :format => :json
          @parsed = JSON.parse(response.body)
        end
        it "responds with 404 not found" do
          response.status.should == 404
        end
        it "responds with error message" do
          @parsed['error'].should == "relationship not found"
        end
      end
    end
  end
  
  ### POST CREATE ========================================================
  describe "post CREATE" do
    it_should_behave_like "a protected action" do
      let(:data) { FactoryGirl.attributes_for(:v1_relationship) }
      def action(args_hash)
        post :create, :relationship => args_hash[:data], :format => args_hash[:format] 
      end   
    end
           
    context "with valid authorization token" do 
      def post_relation attrs, format        
        request.env['X-AUTH-TOKEN'] = @auth_token
        post :create, :relationship => attrs, :format => format 
      end
      context "with XML or HTML format" do
        [:xml, :html].each do |format|
          before :each do
            given_relation_attrs_with({ :valid_asset => true, :valid_portfolio => true}) do |attrs|
               post_relation(attrs, :json)
            end        
          end
          it "should return 200 code for format #{format}" do
            response.status.should == 200  
          end
        end          
      end
      context "with JSON format" do
        context "with valid attributes" do
          it "increases number of relationships by 1" do   
            expect{
              given_relation_attrs_with({ :valid_asset => true, :valid_portfolio => true}) do |attrs|
                 post_relation(attrs, :json)
              end
            }.to change(V1::Relationship, :count).by(1)
          end    
          
          before :each do
            given_relation_attrs_with({ :valid_asset => true, :valid_portfolio => true}) do |attrs|
               post_relation(attrs, :json)
            end
          end
          it_should_behave_like "an action that responds with JSON"       
          it "responds with success 200 status code" do
            response.status.should == 200       
          end
          it "responds with Location header" do
            response.header['Location'].should be_present
          end
        end
        context "with invalid attributes" do
          context "portfolio does not exist" do
            it "does not increase the number of relationships" do   
              expect{
                given_relation_attrs_with({ :valid_asset => true, :valid_portfolio => false}) do |attrs|
                   post_relation(attrs, :json)
                end
              }.to_not change(V1::Relationship, :count)
            end
            before :each do
              given_relation_attrs_with({ :valid_asset => true, :valid_portfolio => false}) do |attrs|
                 post_relation(attrs, :json)
              end
            end
            it_should_behave_like "an action that responds with JSON"       
            it "responds with unprocessable 422 status code" do
              response.status.should == 422       
            end
            it "responds with missing portfolio error" do
              parsed = JSON.parse(response.body)
              parsed['error'].should =~ /portfolio with id \d+ not found/
            end
          end
          context "asset does not exist" do
            it "does not increase the number of relationships" do   
              expect{
                given_relation_attrs_with({ :valid_asset => false, :valid_portfolio => true}) do |attrs|
                   post_relation(attrs, :json)
                end
              }.to_not change(V1::Relationship, :count)
            end
            before :each do
              given_relation_attrs_with({ :valid_asset => false, :valid_portfolio => true}) do |attrs|
                 post_relation(attrs, :json)
              end
            end
            it_should_behave_like "an action that responds with JSON"       
            it "responds with unprocessable 422 status code" do
              response.status.should == 422       
            end
            it "responds with missing portfolio error" do
              parsed = JSON.parse(response.body)
              parsed['error'].should =~ /asset with id \d+ not found/
            end
          end
          context "relationship already exists between asset and portfolio" do
            before :each do
              given_relation_attrs_with({ :valid_asset => true, :valid_portfolio => true}) do |attrs|
                 post_relation(attrs, :json)
                 post_relation(attrs, :json)
              end
            end
            it_should_behave_like "an action that responds with JSON"       
            it "responds with unprocessable 422 status code" do
              response.status.should == 422   
            end
            it "responds with missing portfolio error" do
              parsed = JSON.parse(response.body)
              parsed['error'].should =~ /relationship already exists/
            end
          end
        end
      end
    end
  end
end