require 'spec_helper'

describe V1::MetadataTemplatesController, :type => :controller do
  include LoginHelper

  before :all do 
    create_test_user
  end

  after :all do
    destroy_test_user
  end

  let(:template) { FactoryGirl.create(:v1_metadata_template) }

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

  ### post CREATE =============================================================
  describe "post CREATE" do
    it_should_behave_like "a protected action" do
      let(:data) { FactoryGirl.attributes_for(:v1_metadata_template) }
      def action(args_hash)
        post :create, :metadata_template => args_hash[:data], :format => args_hash[:format] 
      end   
    end

    context "with valid authorization token" do 
      def post_template attrs, format
        request.env['X-AUTH-TOKEN'] = @auth_token
        post :create, :metadata_template => attrs, :format => format 
      end  
      context "with XML or HTML format" do
        [:xml, :html].each do |format|
          before :each do
            post_template(FactoryGirl.attributes_for(:v1_metadata_template), format)        
          end
          it "should return 406 code for format #{format}" do
            response.status.should == 406  
          end
          it "does not create the template" do
            expect{ 
              post_template(FactoryGirl.attributes_for(:v1_metadata_template), format)
            }.to_not change(V1::MetadataTemplate, :count)
          end
        end          
      end    
      context "with JSON format" do    
        context "with invalid attributes" do
          let(:valid_attrs) { FactoryGirl.attributes_for(:v1_metadata_template) }
          context "with duplicate name" do
            let(:dup_attrs) do
              attrs = FactoryGirl.attributes_for(:v1_metadata_template)
              attrs[:name] = valid_attrs[:name]
              attrs
            end
            before :each do
              FactoryGirl.create(:v1_metadata_template, valid_attrs)
            end
            it "does not create an metadata template" do
              expect{ 
                post_template(dup_attrs, :json)
              }.to_not change(V1::MetadataTemplate, :count)
            end
            it "responds with 409 conflict" do
              post_template(dup_attrs, :json)
              response.status.should == 409
            end
          end
        end
        context "missing required attributes" do
          let(:valid_attrs) { FactoryGirl.attributes_for(:v1_metadata_template) }
          let(:invalid_attrs) { 
            valid_attrs.delete(:name)
            valid_attrs
          }
          it "does not create an metadata template" do
            expect{ 
              post_template(invalid_attrs, :json)
            }.to_not change(V1::MetadataTemplate, :count)
          end
          it "responds with 422 unprocessable entity" do
            post_template(invalid_attrs, :json)
            response.status.should == 422
          end
        end

        context "with valid attributes" do
          it "creates one template" do   
            expect{ 
              post_template(FactoryGirl.attributes_for(:v1_metadata_template), :json)
            }.to change(V1::MetadataTemplate, :count).by(1)
          end 
          before :each do
            post_template(FactoryGirl.attributes_for(:v1_metadata_template), :json)
          end
          it_should_behave_like "an action that responds with JSON"       
          it "responds with success 200 status code" do
            response.status.should == 200       
          end
          it "responds with Location header" do
            response.header['Location'].should be_present
          end
          context "with associated field settings" do
            it "creates the field settings as well" do
              expect {
                template = FactoryGirl.attributes_for(:v1_metadata_template)
                field = FactoryGirl.create(:v1_metadata_field)
                settings_hash = [{ :field_id => field.id, :required => false, :order => 1}]
                template[:metadata_template_field_settings] = settings_hash
                post_template(template, :json)
              }.to change(V1::MetadataTemplateFieldSetting, :count).by(1)
            end
          end

        end
      end
    end
  end


end
