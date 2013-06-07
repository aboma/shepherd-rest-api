require "spec_helper"

describe V1::MetadataValuesListsController, :type => :controller do
  include LoginHelper

  before :all do 
    create_test_user
  end

  after :all do
    destroy_test_user
  end

  let(:list) { FactoryGirl.create(:v1_values_list) }

  ### INDEX ======================================================
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

  ### SHOW ========================================================
  describe "get SHOW" do
    context "unauthorized user" do
      it_should_behave_like "a protected action" do
        let(:data) { { :id => list.id } }
        def action(args_hash)
          get :show, args_hash[:data], :format => args_hash[:format]
        end
      end
    end
    context "with valid authorization token" do
      context "with valid values list id" do
        before :each do
          request.env['X-AUTH-TOKEN'] = @auth_token
          get :show, :id => list.id, :format => :json
          @parsed = JSON.parse(response.body)
        end
        it_should_behave_like "an action that responds with JSON"
        it "responds with the asked for values list" do
          @parsed['metadata_values_list']['id'].should == list.id
        end
      end
      context "invalid values list id" do
        before :each do
          request.env['X-AUTH-TOKEN'] = @auth_token
          get :show, :id => list.id + 111, :format => :json
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
      let(:data) { FactoryGirl.attributes_for(:v1_values_list) }
      def action(args_hash)
        post :create, :metadata_values_list => args_hash[:data], :format => args_hash[:format] 
      end   
    end

    context "with valid authorization token" do 
      def post_list attrs, format
        request.env['X-AUTH-TOKEN'] = @auth_token
        post :create, :metadata_values_list => attrs, :format => format
      end  
      context "with XML or HTML format" do
        [:xml, :html].each do |format|
          before :each do
            post_list(FactoryGirl.attributes_for(:v1_values_list), format)        
          end
          it "should return 406 code for format #{format}" do
            response.status.should == 406  
          end
          it "does not create the values list" do
            expect{ 
              post_list(FactoryGirl.attributes_for(:v1_values_list), format)
            }.to_not change(V1::MetadataValuesList, :count)
          end
        end          
      end    
      context "with JSON format" do    
        context "with invalid attributes" do
          let(:valid_attrs) { FactoryGirl.attributes_for(:v1_values_list) }
          let(:dup_attrs) {
            attrs = FactoryGirl.attributes_for(:v1_values_list)
            attrs[:name] = valid_attrs[:name]
            attrs
          }
          before :each do
            FactoryGirl.create(:v1_values_list, valid_attrs)
          end
          it "does not create an metadata values list" do
            expect{ 
              post_list(dup_attrs, :json)
            }.to_not change(V1::MetadataValuesList, :count)
          end
          it "responds with 409 conflict" do
            post_list(dup_attrs, :json)
            response.status.should == 409
          end
        end
        context "missing required attributes" do
          let(:valid_attrs) { FactoryGirl.attributes_for(:v1_values_list) }
          let(:invalid_attrs) { 
            valid_attrs.delete(:name)
            valid_attrs
          }
          it "does not create an metadata values list" do
            expect{ 
              post_list(invalid_attrs, :json)
            }.to_not change(V1::MetadataValuesList, :count)
          end
          #subject {}
          it "responds with 422 unprocessable entity" do
            post_list(invalid_attrs, :json)
            response.status.should == 422
          end
        end

        context "with valid attributes" do
          it "creates one values list" do   
            expect{ 
              post_list(FactoryGirl.attributes_for(:v1_values_list), :json)
            }.to change(V1::MetadataValuesList, :count).by(1)
          end 
          before :each do
            post_list(FactoryGirl.attributes_for(:v1_values_list), :json)
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
