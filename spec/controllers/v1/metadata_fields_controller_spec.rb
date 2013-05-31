require 'spec_helper'

describe V1::MetadataFieldsController, :type => :controller do
  include LoginHelper

  before :all do 
    create_test_user
  end

  after :all do
    destroy_test_user
  end

  let(:field) { FactoryGirl.create(:v1_metadata_field) }

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

  describe "get SHOW" do
    context "unauthorized user" do
      it_should_behave_like "a protected action" do
        let(:data) { { :id => field.id } }
        def action(args_hash)
          get :show, args_hash[:data], :format => args_hash[:format]
        end
      end
    end
    context "with valid authorization token" do
      context "with valid field id" do
        before :each do
          request.env['X-AUTH-TOKEN'] = @auth_token
          get :show, :id => field.id, :format => :json
          @parsed = JSON.parse(response.body)
        end
        it_should_behave_like "an action that responds with JSON"
        it "responds with the asked for field" do
          @parsed['metadata_field']['id'].should == field.id
        end
      end
      context "invalid field id" do
        before :each do
          request.env['X-AUTH-TOKEN'] = @auth_token
          get :show, :id => field.id + 111, :format => :json
          @parsed = JSON.parse(response.body)
        end
        it_should_behave_like "an action that responds with JSON"
        it "responds with 404 not found" do
          response.status.should == 404
        end
      end
    end
  end

  describe "post CREATE" do
    it_should_behave_like "a protected action" do
      let(:data) { FactoryGirl.attributes_for(:v1_metadata_field) }
      def action(args_hash)
        post :create, :metadata_field => args_hash[:data], :format => args_hash[:format] 
      end   
    end

    context "with valid authorization token" do 
      def post_field attrs, format
        request.env['X-AUTH-TOKEN'] = @auth_token
        post :create, :metadata_field => attrs, :format => format 
      end  
      context "with XML or HTML format" do
        [:xml, :html].each do |format|
          before :each do
            post_field(FactoryGirl.attributes_for(:v1_metadata_field), format)        
          end
          it "should return 406 code for format #{format}" do
            response.status.should == 406  
          end
          it "does not create the field" do
            expect{ 
              post_field(FactoryGirl.attributes_for(:v1_metadata_field), format)
            }.to_not change(V1::MetadataField, :count)
          end
        end          
      end    
      context "with JSON format" do    
        context "with invalid attributes" do
          let(:valid_attrs) { FactoryGirl.attributes_for(:v1_metadata_field) }
          let(:dup_attrs) {
            attrs = FactoryGirl.attributes_for(:v1_metadata_field)
            attrs[:name] = valid_attrs[:name]
            attrs
          }
          before :each do
            FactoryGirl.create(:v1_metadata_field, valid_attrs)
          end
          it "does not create an metadata field" do
            expect{ 
              post_field(dup_attrs, :json)
            }.to_not change(V1::MetadataField, :count)
          end
          it "responds with 409 conflict" do
            post_field(dup_attrs, :json)
            response.status.should == 409
          end
        end
        context "missing required attributes" do
          let(:valid_attrs) { FactoryGirl.attributes_for(:v1_metadata_field) }
          let(:invalid_attrs) { 
            valid_attrs.delete(:name)
            valid_attrs
          }
          it "does not create an metadata field" do
            expect{ 
              post_field(invalid_attrs, :json)
            }.to_not change(V1::MetadataField, :count)
          end
          #subject {}
          it "responds with 422 unprocessable entity" do
            post_field(invalid_attrs, :json)
            response.status.should == 422
          end
        end

        context "with valid attributes" do
          it "creates one field" do   
            expect{ 
              post_field(FactoryGirl.attributes_for(:v1_metadata_field), :json)
            }.to change(V1::MetadataField, :count).by(1)
          end 
          before :each do
            post_field(FactoryGirl.attributes_for(:v1_metadata_field), :json)
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

  ### post UPDATE =========================================================
  describe "post UPDATE" do
    it_should_behave_like "a protected action" do
      let(:data) { FactoryGirl.attributes_for(:v1_metadata_field) }
      def action(args_hash)
        post :update, :id => field.id, :metadata_field => args_hash[:data], :format => args_hash[:format] 
      end   
    end

    context "with valid authorization token" do
      def post_update_field attrs, format
        request.env['X-AUTH-TOKEN'] = @auth_token
        post :update, :id => field.id, :metadata_field => attrs, :format => format 
      end  
      context "with XML or HTML format" do
        [:xml, :html].each do |format|
          before :each do
            post_update_field( { :name => 'new name' } , format)
          end
          it_should_behave_like "an action that responds with JSON"       
          it "returns 406 code for format #{format}" do
            response.status.should == 406  
          end
        end          
      end
      context "JSON format" do
        context "valid input" do
          before :each do
            post_update_field({ :name => 'new name' }, :json)
            @parsed = JSON.parse(response.body)
          end
          it_should_behave_like "an action that responds with JSON"
          it "returns 200 success status code" do
            response.status.should == 200
          end
          it "returns the updated field" do
            @parsed['metadata_field']['id'].should == field.id
          end
        end
        context "invalid input" do
          describe "invalid field id" do
            it "returns status code 404 not found" do
              field.id = '1111'   # change field id to one that does not exist
              post_update_field({ :name => 'new name' }, :json)
              response.status.should == 404
            end
          end
        end
      end
    end
  end
end
