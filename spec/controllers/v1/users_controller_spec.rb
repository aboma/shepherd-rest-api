require 'spec_helper'

describe V1::UsersController, type: :controller do
  include LoginHelper

  let(:user) { FactoryGirl.create(:v1_user) }

  ### GET INDEX ==================================================
  describe 'get INDEX' do
    context 'unauthorized user' do
      it_should_behave_like 'a protected action' do
        def action(args_hash)
          get :index, format: args_hash[:format]
        end      
      end 
    end
    context 'with valid authorization' do
      def get_index(format)
        login_user
        get :index, format: format 
      end
      context 'with XML or HTML format' do
        [:xml, :html].each do |format|
          before :each do 
            get_index(format) 
          end
          it_should_behave_like 'responds with 406 not acceptable'
        end
      end
      context 'with JSON format' do
        it_should_behave_like 'JSON controller index action'        
      end
    end
  end

  ### GET SHOW ====================================================
  describe 'get SHOW' do
    context 'unauthorized user' do
      it_should_behave_like 'a protected action' do
        let(:data) { { id: user.id } }
        def action(args_hash)
          get :show, args_hash[:data], format: args_hash[:format]
        end
      end
    end
    context 'with valid authorization' do
      context 'with valid user id' do
        before :each do
          login_user
          get :show, id: user.id, format: :json
          @parsed = JSON.parse(response.body)
        end
        it_should_behave_like 'an action that responds with JSON'
        it 'responds with the asked for user' do
          @parsed['user']['id'].should == user.id
        end
      end
      context 'invalid user id' do
        before :each do
          login_user
          get :show, id: user.id + 1111, format: :json
          @parsed = JSON.parse(response.body)
        end
        it_should_behave_like 'an action that responds with JSON'
        it_should_behave_like 'responds with 404 not found'
      end
    end
  end

  describe 'post CREATE' do
    it_should_behave_like 'a protected action' do
      let(:data) { FactoryGirl.attributes_for(:v1_user) }
      def action(args_hash)
        post :create, user: args_hash[:data], format: args_hash[:format] 
      end   
    end

    context 'with valid authorization' do 
      def post_user attrs, format
        post :create, user: attrs, format: format 
      end  
      context 'with XML or HTML format' do
        [:xml, :html].each do |format|
          before :each do
            login_user
            post_user(FactoryGirl.attributes_for(:v1_user), format)        
          end
          it_should_behave_like 'responds with 406 not acceptable'
          it 'does not create the user' do
            login_user
            expect do
              post_user(FactoryGirl.attributes_for(:v1_user), format)
            end.to_not change(V1::User, :count)
          end
        end          
      end    
      context 'with JSON format' do    
        context 'with invalid attributes' do
          let(:valid_attrs) { FactoryGirl.attributes_for(:v1_user) }
          let(:dup_attrs) {
            attrs = FactoryGirl.attributes_for(:v1_user)
            attrs[:email] = valid_attrs[:email]
            attrs
          }
          before :each do
            FactoryGirl.create(:v1_user, valid_attrs)
          end
          it 'does not create an user' do
            login_user
            expect do 
              post_user(dup_attrs, :json)
            end.to_not change(V1::User, :count)
          end
          it 'responds with 409 conflict' do
            login_user
            post_user(dup_attrs, :json)
            response.status.should == 409
          end
        end
        context 'missing required attributes' do
          let(:valid_attrs) { FactoryGirl.attributes_for(:v1_user) }
          let(:invalid_attrs) { 
            valid_attrs.delete(:email)
            valid_attrs
          }
          it 'does not create an user' do
            login_user
            expect do
              post_user(invalid_attrs, :json)
            end.to_not change(V1::User, :count)
          end
          it 'responds with 422 unprocessable entity' do
            login_user
            post_user(invalid_attrs, :json)
            response.status.should == 422
          end
        end

        context 'with valid attributes' do
          it 'creates one user' do   
            login_user
            expect do 
              post_user(FactoryGirl.attributes_for(:v1_user), :json)
            end.to change(V1::User, :count).by(1)
          end 
          before :each do
            login_user
            post_user(FactoryGirl.attributes_for(:v1_user), :json)
          end
          it_should_behave_like 'an action that responds with JSON'       
          it_should_behave_like 'responds with success 201 status code'
          it_should_behave_like 'responds with Location header'
        end
      end
    end
  end

  ### put UPDATE =========================================================
  describe 'put UPDATE' do
    it_should_behave_like 'a protected action' do
      let(:data) { FactoryGirl.attributes_for(:v1_user) }
      def action(args_hash)
        post :update, id: user.id, user: args_hash[:data], format: args_hash[:format] 
      end   
    end

    context 'with valid authorization' do
      def update_user attrs, format
        login_user
        post :update, id: user.id, user: attrs, format: format 
      end  
      context 'with XML or HTML format' do
        [:xml, :html].each do |format|
          before :each do
            update_user( { name: 'new name' } , format)
          end
          it_should_behave_like 'responds with 406 not acceptable'
        end          
      end
      context 'JSON format' do
        context 'valid input' do
          before :each do
            update_user({ name: 'new name' }, :json)
            @parsed = JSON.parse(response.body)
          end
          it_should_behave_like 'an action that responds with JSON'
          it_should_behave_like 'responds with success 200 status code'
          it 'returns the updated field' do
            @parsed['user']['id'].should == user.id
          end
        end
        context 'invalid input' do
          describe 'invalid user id' do
            before :each do
              user.id = '111111'   # change user id to one that does not exist
              update_user({ name: 'new name' }, :json)
            end
            it_should_behave_like 'responds with 404 not found'
          end
          describe 'already existing user email' do
            it 'returns status 409 conflict' do
              existing_user = FactoryGirl.create(:v1_user)
              update_user( { email: existing_user.email.upcase }, :json )
              response.status.should == 409
            end
          end
        end
      end
    end
  end
end
