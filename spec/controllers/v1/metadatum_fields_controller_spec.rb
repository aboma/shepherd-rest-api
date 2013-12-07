require 'spec_helper'

describe V1::MetadatumFieldsController, type: :controller do
  include LoginHelper

  before :all do 
    create_test_user
  end

  after :all do
    destroy_test_user
  end

  let(:field) { FactoryGirl.create(:v1_metadatum_field) }

  ### get INDEX =========================================================
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

  ### get SHOW =========================================================
  describe 'get SHOW' do
    context 'unauthorized user' do
      it_should_behave_like 'a protected action' do
        let(:data) { { id: field.id } }
        def action(args_hash)
          get :show, args_hash[:data], format: args_hash[:format]
        end
      end
    end
    context 'with valid authorization token' do
      context 'with valid field id' do
        before :each do
          request.env['X-AUTH-TOKEN'] = @auth_token
          get :show, id: field.id, format: :json
          @parsed = JSON.parse(response.body)
        end
        it_should_behave_like 'an action that responds with JSON'
        it 'responds with the asked for field' do
          @parsed['metadatum_field']['id'].should == field.id
        end
      end
      context 'invalid field id' do
        before :each do
          request.env['X-AUTH-TOKEN'] = @auth_token
          get :show, id: field.id + 111, format: :json
          @parsed = JSON.parse(response.body)
        end
        it_should_behave_like 'an action that responds with JSON'
        it 'responds with 404 not found' do
          response.status.should == 404
        end
      end
    end
  end

  ### post CREATE =========================================================
  describe 'post CREATE' do
    it_should_behave_like 'a protected action' do
      let(:data) { FactoryGirl.attributes_for(:v1_metadatum_field) }
      def action(args_hash)
        post :create, metadatum_field: args_hash[:data], format: args_hash[:format] 
      end   
    end

    context 'with valid authorization token' do 
      def post_field attrs, format
        request.env['X-AUTH-TOKEN'] = @auth_token
        post :create, metadatum_field: attrs, format: format 
      end  
      context 'with XML or HTML format' do
        [:xml, :html].each do |format|
          before :each do
            post_field(FactoryGirl.attributes_for(:v1_metadatum_field), format)        
          end
          it "should return 406 code for format #{format}" do
            response.status.should == 406  
          end
          it 'does not create the field' do
            expect do 
              post_field(FactoryGirl.attributes_for(:v1_metadatum_field), format)
            end.to_not change(V1::MetadatumField, :count)
          end
        end          
      end    
      context 'with JSON format' do    
        context 'with invalid attributes' do
          let(:valid_attrs) { FactoryGirl.attributes_for(:v1_metadatum_field) }
          context 'with duplicate name' do
            let(:dup_attrs) do
              attrs = FactoryGirl.attributes_for(:v1_metadatum_field)
              attrs[:name] = valid_attrs[:name]
              attrs
            end
            before :each do
              FactoryGirl.create(:v1_metadatum_field, valid_attrs)
            end
            it 'does not create an metadata field' do
              expect do 
                post_field(dup_attrs, :json)
              end.to_not change(V1::MetadatumField, :count)
            end
            it 'responds with 409 conflict' do
              post_field(dup_attrs, :json)
              response.status.should == 409
            end
          end
          context 'invalid list id' do
            let(:invalid_attrs) do
              attrs = FactoryGirl.attributes_for(:v1_metadatum_field)
              attrs[:allowed_values_list_id] = 999999
              attrs
           end
            it 'does not create a metadata field' do
              expect do
                post_field(invalid_attrs, :json)
              end.to_not change(V1::MetadatumField, :count)
            end
            it 'responds with 422 unprocessable entity' do
              post_field(invalid_attrs, :json)
              response.status.should == 422
            end
          end
        end
        context 'missing required attributes' do
          let(:valid_attrs) { FactoryGirl.attributes_for(:v1_metadatum_field) }
          let(:invalid_attrs) { 
            valid_attrs.delete(:name)
            valid_attrs
          }
          it 'does not create an metadata field' do
            expect do 
              post_field(invalid_attrs, :json)
            end.to_not change(V1::MetadatumField, :count)
          end
          #subject {}
          it 'responds with 422 unprocessable entity' do
            post_field(invalid_attrs, :json)
            response.status.should == 422
          end
        end

        context 'with valid attributes' do
          it 'creates one field' do   
            expect do
              post_field(FactoryGirl.attributes_for(:v1_metadatum_field), :json)
            end.to change(V1::MetadatumField, :count).by(1)
          end 
          before :each do
            post_field(FactoryGirl.attributes_for(:v1_metadatum_field), :json)
          end
          it_should_behave_like 'an action that responds with JSON'       
          it_should_behave_like 'responds with success 200 status code'
          it_should_behave_like 'responds with Location header'
        end
      end
    end
  end

  ### put UPDATE =========================================================
  describe 'post UPDATE' do
    it_should_behave_like 'a protected action' do
      let(:data) { FactoryGirl.attributes_for(:v1_metadatum_field) }
      def action(args_hash)
        post :update, id: field.id, metadatum_field: args_hash[:data], format: args_hash[:format] 
      end   
    end

    context 'with valid authorization token' do
      def post_update_field attrs, format
        request.env['X-AUTH-TOKEN'] = @auth_token
        post :update, id: field.id, metadatum_field: attrs, format: format 
      end  
      context 'with XML or HTML format' do
        [:xml, :html].each do |format|
          before :each do
            post_update_field({ name: 'new name' } , format)
          end
          it "returns 406 code for format #{format}" do
            response.status.should == 406  
          end
        end          
      end
      context 'JSON format' do
        context 'valid input' do
          before :each do
            post_update_field({ name: 'new name' }, :json)
            @parsed = JSON.parse(response.body)
          end
          it_should_behave_like 'an action that responds with JSON'
          it_should_behave_like 'responds with success 200 status code'
          it 'returns the updated field' do
            @parsed['metadatum_field']['id'].should == field.id
          end
        end
        context 'invalid input' do
          describe 'invalid field id' do
            it 'returns status code 404 not found' do
              field.id = '1111'   # change field id to one that does not exist
              post_update_field({ name: 'new name' }, :json)
              response.status.should == 404
            end
          end
          describe 'already existing field name' do
            it 'returns status 409 conflict' do
              existing_field = FactoryGirl.create(:v1_metadatum_field)
              post_update_field({ name: existing_field.name.upcase }, :json )
              response.status.should == 409
            end
          end
        end
      end
    end
  end

  ### delete DESTROY =========================================================
  describe 'delete DESTROY' do
    # object must be created outside of the expects statement
    let!(:field_to_delete) { field }
    context 'unauthorized user' do
      it_should_behave_like 'a protected action' do 
        let(:id) { field_to_delete.id }
        def action(args_hash)
          delete :destroy, id: args_hash[:id] , format: args_hash[:format] 
        end   
      end
    end         
    context 'with valid authorization token' do
      def delete_field(id, format)
        request.env['X-AUTH-TOKEN'] = @auth_token
        delete :destroy, id: id, format: format
      end
      context 'with XML or HTML format' do
        [:xml, :html].each do |format|
          it 'does not change the number of fields' do   
            expect do
              delete_field(field_to_delete.id, format)
            end.to_not change(V1::MetadatumField, :count)
          end
          before :each do
            delete_field(field_to_delete.id, format)    
          end
          it "should return 406 code for format #{format}" do
            response.status.should == 406  
          end
        end          
      end
      context 'with JSON format' do
        context 'with valid parameters' do
          it 'decreases number of fields by 1' do   
            expect do
              delete_field(field_to_delete.id, :json)
            end.to change(V1::MetadatumField, :count).by(-1)
          end
          it 'should respond with JSON' do
            delete_field(field_to_delete.id, :json)
            response.header['Content-Type'].should include 'application/json'          
          end
          it 'responds with success 200 status code' do
            delete_field(field_to_delete.id, :json)
            response.status.should == 200       
          end
        end
        context 'with field referenced by template' do
          def setup_template_with_field
            template = FactoryGirl.create(:v1_metadata_template)
            attrs = FactoryGirl.attributes_for(:v1_template_field_setting)
            attrs[:metadata_template_id] = template.id
            attrs[:metadatum_field_id] = field_to_delete.id
            FactoryGirl.create(:v1_template_field_setting, attrs)
          end
          it 'does not delete the field' do
            expect do
              setup_template_with_field
              delete_field(field_to_delete.id, :json)
            end.to_not change(V1::MetadatumField, :count)
          end
          it 'responds with unprocessable entity' do
            setup_template_with_field
            delete_field(field_to_delete.id, :json)
            response.status.should == 422
          end
        end
      end
    end
  end
end
