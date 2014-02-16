require 'spec_helper'

describe V1::MetadatumValuesListsController, type: :controller do
  include LoginHelper

  let(:list) { FactoryGirl.create(:v1_values_list) }

  ### INDEX ======================================================
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

  ### SHOW ========================================================
  describe 'get SHOW' do
    context 'unauthorized user' do
      it_should_behave_like 'a protected action' do
        let(:data) { { id: list.id } }
        def action(args_hash)
          get :show, args_hash[:data], format: args_hash[:format]
        end
      end
    end
    context 'with valid authorization token' do
      context 'with valid values list id' do
        before :each do
          login_user
          get :show, id: list.id, format: :json
          @parsed = JSON.parse(response.body)
        end
        it_should_behave_like 'an action that responds with JSON'
        it 'responds with the asked for values list' do
          @parsed['metadatum_values_list']['id'].should == list.id
        end
      end
      context 'invalid values list id' do
        before :each do
          login_user
          get :show, id: list.id + 111, format: :json
        end
        it_should_behave_like 'an action that responds with JSON'
        it_should_behave_like 'responds with 404 not found'
      end
    end
  end

  ### post CREATE ========================================================
  describe 'post CREATE' do
    it_should_behave_like 'a protected action' do
      let(:data) { FactoryGirl.attributes_for(:v1_values_list) }
      def action(args_hash)
        post :create, metadatum_values_list: args_hash[:data], format: args_hash[:format] 
      end   
    end

    context 'with valid authorization token' do 
      def post_list attrs, format
        login_user
        post :create, metadatum_values_list: attrs, format: format
      end  
      context 'with XML or HTML format' do
        [:xml, :html].each do |format|
          before :each do
            post_list(FactoryGirl.attributes_for(:v1_values_list), format)        
          end
          it_should_behave_like 'responds with 406 not acceptable'
          it 'does not create the values list' do
            expect do 
              post_list(FactoryGirl.attributes_for(:v1_values_list), format)
            end.to_not change(V1::MetadatumValuesList, :count)
          end
        end          
      end    
      context 'with JSON format' do    
        context 'with invalid attributes' do
          let(:valid_attrs) { FactoryGirl.attributes_for(:v1_values_list) }
          let(:dup_attrs) {
            attrs = FactoryGirl.attributes_for(:v1_values_list)
            attrs[:name] = valid_attrs[:name]
            attrs
          }
          before :each do
            FactoryGirl.create(:v1_values_list, valid_attrs)
          end
          it 'does not create an metadata values list' do
            expect do
              post_list(dup_attrs, :json)
            end.to_not change(V1::MetadatumValuesList, :count)
          end
          it 'responds with 409 conflict' do
            post_list(dup_attrs, :json)
            expect(response.status).to eq(409)
          end
        end
        context 'missing required attributes' do
          let(:valid_attrs) { FactoryGirl.attributes_for(:v1_values_list) }
          let(:invalid_attrs) { 
            valid_attrs.delete(:name)
            valid_attrs
          }
          it 'does not create an metadata values list' do
            expect do
              post_list(invalid_attrs, :json)
            end.to_not change(V1::MetadatumValuesList, :count)
          end
          it 'responds with 422 unprocessable entity' do
            post_list(invalid_attrs, :json)
            expect(response.status).to eq(422)
          end
        end

        context 'with valid attributes' do
          it 'creates one values list' do   
            expect do
              post_list(FactoryGirl.attributes_for(:v1_values_list), :json)
            end.to change(V1::MetadatumValuesList, :count).by(1)
          end 
          before :each do
            post_list(FactoryGirl.attributes_for(:v1_values_list), :json)
          end
          it_should_behave_like 'an action that responds with JSON'       
          it_should_behave_like 'responds with success 201 status code'
          it_should_behave_like 'responds with Location header'
          context 'with associated values' do
            it 'creates those values as well' do
              expect do
                values_list = FactoryGirl.attributes_for(:v1_values_list)
                values = [{ value: 'list value #1'}, { value: "list value #2" }]
                values_list[:metadatum_list_values] = values
                post_list(values_list, :json)
              end.to change(V1::MetadatumListValue, :count).by(2)
            end
          end
        end
      end
    end
  end

  ### PUT UPDATE ========================================================
  describe 'put UPDATE' do
    it_should_behave_like 'a protected action' do
      let(:data) { { name: :updated_name } }
      let(:id) { list.id }
      def action(args_hash)
        put :update, id: args_hash[:id], metadatum_values_list: args_hash[:data] , format: args_hash[:format] 
      end   
    end

    context 'authorized user' do
      def update_list(attrs, format)
        login_user
        put :update, id: list.id, metadatum_values_list: attrs , format: format         
      end
      context 'HTML or XML format' do
        [:html, :xml].each do |format|
          before :each do
            update_list({ description: :boom }, format )
          end
          it_should_behave_like 'responds with 406 not acceptable' 
        end
      end
      context 'JSON format' do
        context 'valid input' do
          before :each do
            update_list({ description: :boom }, :json )
            @parsed = JSON.parse(response.body)
          end
          it_should_behave_like 'an action that responds with JSON'
          it_should_behave_like 'responds with success 200 status code'
          it 'returns the updated metadata list' do
            @parsed['metadatum_values_list']['id'].should == list.id
          end
        end
        context 'invalid input' do
          describe 'invalid list id' do
            it 'returns status code 404 not found' do
              list.id = '1111'   # change metadatum_list_value id to one that does not exist
              update_list({ name: 'test' }, :json )
              expect(response.status).to eq(404)
            end
          end
        end
      end
    end
  end

  ### delete DESTROY =========================================================
  describe 'delete DESTROY' do
    # object must be created outside of the expects statement
    let!(:list_to_delete) { list }
    context 'unauthorized user' do
      it_should_behave_like 'a protected action' do 
        let(:id) { list.id }
        def action(args_hash)
          delete :destroy, id: args_hash[:id] , format: args_hash[:format] 
        end   
      end
    end         
    context 'with valid authorization token' do
      def delete_list(id, format)
        login_user
        delete :destroy, id: id, format: format 
      end
      context 'with XML or HTML format' do
        [:xml, :html].each do |format|
          it 'does not change the number of lists' do   
            expect do
              delete_list(list_to_delete.id, format)
            end.to_not change(V1::MetadatumValuesList, :count)
          end
          it "should return 406 code for format #{format}" do
            delete_list(list.id, format)    
            expect(response.status).to eq(406)  
          end
        end          
      end
      context 'with JSON format' do
        it 'decreases number of lists by 1' do   
          expect do
            delete_list(list_to_delete.id, :json)
          end.to change(V1::MetadatumValuesList, :count).by(-1)
        end
        it 'deletes associated list values as well' do
          attrs = FactoryGirl.attributes_for(:v1_value)
          attrs[:metadatum_values_list_id] = list_to_delete.id
          FactoryGirl.create(:v1_value, attrs)
          expect do
            delete_list(list_to_delete, :json)
          end.to change(V1::MetadatumListValue, :count).by(-1)
        end
        context "" do
          before :each do
            delete_list(list.id, :json)
          end
          it_should_behave_like 'an action that responds with JSON'
          it_should_behave_like 'responds with success 200 status code'
        end
      end
    end
  end
end
