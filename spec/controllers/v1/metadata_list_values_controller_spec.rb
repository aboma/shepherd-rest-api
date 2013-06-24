require "spec_helper"

describe V1::MetadataListValuesController, :type => :controller do
  include LoginHelper

  before :all do 
    create_test_user
  end

  after :all do
    destroy_test_user
  end

  let(:value) { FactoryGirl.create(:v1_value) }


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


  describe "post CREATE" do
    it_should_behave_like "a protected action" do
      let(:data) { FactoryGirl.attributes_for(:v1_value) }
      def action(args_hash)
        post :create, :metadata_list_value => args_hash[:data], :format => args_hash[:format] 
      end   
    end

    context "with valid authorization token" do 
      def post_field attrs, format
        request.env['X-AUTH-TOKEN'] = @auth_token
        post :create, :metadata_list_value => attrs, :format => format 
      end  
      context "with XML or HTML format" do
        [:xml, :html].each do |format|
          before :each do
            post_field(FactoryGirl.attributes_for(:v1_value), format)          
          end
          it "should return 406 code for format #{format}" do
            response.status.should == 406  
          end
          it "does not create the value" do
            expect{ 
              post_field(FactoryGirl.attributes_for(:v1_value), format)
            }.to_not change(V1::MetadataListValue, :count)
          end
        end          
      end    
      context "with JSON format" do    
        context "with invalid attributes" do
          let(:invalid_attrs) {
            attrs = FactoryGirl.attributes_for(:v1_value)
            attrs[:value] = nil 
            attrs
          }
          it "does not create an metadata value" do
            expect{ 
              post_field(invalid_attrs, :json)
            }.to_not change(V1::MetadataListValue, :count)
          end
          it "responds with 422 unprocessable entity" do
            post_field(invalid_attrs, :json)
            response.status.should == 422
          end
        end
        context "missing required attributes" do
          let(:valid_attrs) { FactoryGirl.attributes_for(:v1_value) }
          let(:invalid_attrs) { 
            valid_attrs.delete(:value)
            valid_attrs
          }
          it "does not create an metadata value" do
            expect{ 
              post_field(invalid_attrs, :json)
            }.to_not change(V1::MetadataListValue, :count)
          end
          #subject {}
          it "responds with 422 unprocessable entity" do
            post_field(invalid_attrs, :json)
            response.status.should == 422
          end
        end

        context "with valid attributes" do
          it "creates one value" do   
            expect{ 
              post_field(FactoryGirl.attributes_for(:v1_value), :json)
            }.to change(V1::MetadataListValue, :count).by(1)
          end 
          before :each do
            post_field(FactoryGirl.attributes_for(:v1_value), :json)
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
