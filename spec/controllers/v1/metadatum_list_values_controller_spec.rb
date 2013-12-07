require 'spec_helper'

describe V1::MetadatumListValuesController, type: :controller do
  include LoginHelper

  before :all do 
    create_test_user
  end

  after :all do
    destroy_test_user
  end

  def given_value_with_attrs(options)
    attrs = FactoryGirl.attributes_for(:v1_value)
    attrs[:metadatum_values_list_id] = FactoryGirl.create(:v1_values_list).id if options[:valid_value]
    attrs[:metadatum_values_list_id] = '12345' unless options[:valid_value]
    yield attrs
  end

  let(:value) do 
    given_value_with_attrs({ valid_value: true }) do |attrs|
      return FactoryGirl.create(:v1_value, attrs) 
    end
  end 


  ### get INDEX ==============================
  describe 'get INDEX' do
    it_should_behave_like 'a protected action' do
      def action(args_hash)
        get :index, format: args_hash[:format]
      end
    end

    context 'with valid authorization token' do
      it_should_behave_like 'JSON controller index action'
    end
  end

  ### get SHOW ==============================
  describe 'get SHOW' do
    pending
  end


  ### POST CREATE ========================================================
  describe 'post CREATE' do
    it_should_behave_like 'a protected action' do
      let(:data) do
        given_value_with_attrs({ valid_value: true }) do |attrs|
          attrs
        end
      end
      def action(args_hash)
        post :create, metadatum_list_value: args_hash[:data], format: args_hash[:format] 
      end   
    end

    context 'with valid authorization token' do 
      def post_value attrs, format
        request.env['X-AUTH-TOKEN'] = @auth_token
        post :create, metadatum_list_value: attrs, format: format 
      end  
      context 'with XML or HTML format' do
        [:xml, :html].each do |format|
          before :each do
            given_value_with_attrs({ valid_value: true }) do |attrs|
              post_value(attrs, format)
            end
          end
          it "should return 406 code for format #{format}" do
            response.status.should == 406  
          end
          it 'does not create the value' do
            expect do 
              given_value_with_attrs({ valid_value: true }) do |attrs|
                post_value(attrs, format)
              end
            end.to_not change(V1::MetadatumListValue, :count)
          end
        end          
      end    
      context 'with JSON format' do    
        context 'with invalid attributes' do
          context 'with no value' do
            let(:invalid_attrs) do 
              given_value_with_attrs({ valid_value: true }) do |attrs|
                attrs[:value] =  ' '
                attrs
              end
            end
            it 'does not create an metadata value' do
              expect do 
                post_value(invalid_attrs, :json)
              end.to_not change(V1::MetadatumListValue, :count)
            end
            it 'responds with 422 unprocessable entity' do
              post_value(invalid_attrs, :json)
              response.status.should == 422
            end
          end
          context 'with invalid metadata list id' do
            let(:invalid_attrs) do 
              given_value_with_attrs({ valid_value: true }) do |attrs|
                attrs[:metadatum_values_list_id] = 999999
                attrs
              end
            end
            it 'does not create an metadata value' do
              expect do
                post_value(invalid_attrs, :json)
              end.to_not change(V1::MetadatumListValue, :count)
            end
            it 'responds with 422 unprocessable entity' do
              post_value(invalid_attrs, :json)
              response.status.should == 422
            end
          end
          context 'with invalid metadata list id' do
            let(:invalid_attrs) do 
              given_value_with_attrs({ valid_value: true }) do |attrs|
                attrs[:metadatum_values_list_id] = 999999
                attrs
              end
            end

          end
        end
        context 'missing required attributes' do
          context 'missing value' do
            let(:invalid_attrs) {
              given_value_with_attrs({ valid_value: true }) do |attrs|
                 attrs.delete(:value)
                 attrs
               end
            }
            it 'does not create an metadata value' do
              expect do
                post_value(invalid_attrs, :json)
              end.to_not change(V1::MetadatumListValue, :count)
            end
            it 'responds with 422 unprocessable entity' do
              post_value(invalid_attrs, :json)
              response.status.should == 422
            end
          end
          context 'missing metadata_value_list_id' do
            let(:invalid_attrs) {
              given_value_with_attrs({ valid_value: true }) do |attrs|
                 attrs.delete(:metadatum_values_list_id)
                 attrs
               end
            }
            it 'does not create an metadata value' do
              expect do
                post_value(invalid_attrs, :json)
              end.to_not change(V1::MetadatumListValue, :count)
            end
            it 'responds with 422 unprocessable entity' do
              post_value(invalid_attrs, :json)
              response.status.should == 422
            end
          end
        end
        context 'with valid attributes' do
          it 'creates one value' do   
            expect do
              given_value_with_attrs({ valid_value: true }) do |attrs|
                post_value(attrs, :json)
              end
            end.to change(V1::MetadatumListValue, :count).by(1)
          end 
          before :each do
            given_value_with_attrs({ valid_value: true }) do |attrs|
              post_value(attrs, :json)
            end
          end
          it_should_behave_like 'an action that responds with JSON'       
          it_should_behave_like 'responds with success 200 status code'
          it_should_behave_like 'responds with Location header'
        end
      end
    end
  end


end
