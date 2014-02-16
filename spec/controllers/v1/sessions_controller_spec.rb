require 'spec_helper'

describe V1::SessionsController, type: :controller do
  include LoginHelper

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'CREATE session' do   
    def post_create_session(args)
      post :create, user: { email: args[:email], password: args[:pw] }, format: args[:format]    
    end
    context 'unauthorized user' do
      context 'HTML or XML format' do                 
        [:xml, :html].each do |format| 
          before :each do
            user = FactoryGirl.create(:v1_user)
            post_create_session email: user.email, pw: '#{@pw}sssss', format: format 
          end
          it_should_behave_like 'responds with 406 not acceptable'
        end
      end
      context 'JSON format' do
        context 'with invalid password for JSON' do
          before :each do
            user = FactoryGirl.create(:v1_user)
            post_create_session email: user.email, pw: '#{@pw}sssss', format: :json
          end
          it_should_behave_like 'responds with 401 unauthorized'
        end    
        context 'with valid password' do
          before :each do
            user = FactoryGirl.create(:v1_user)
            post_create_session email: user.email, pw: user.password, format: :json
            @body = JSON.parse(response.body) 
          end
          it_should_behave_like 'an action that responds with JSON'       
          it_should_behave_like 'responds with success 201 status code'
          it 'returns success message' do
            @body['session']['success'].should be_true
          end
        end
      end
    end
  end

  describe 'SHOW session' do
    context 'authorized user' do
      def show_session
        get :show, id: @user.id, format: :json
      end      
      before :each do
        login_user
        show_session
      end
      it_should_behave_like 'responds with success 200 status code'
    end

    context 'unauthorized user' do
      def show_session_invalid
        get :show, id: 1111111, format: :json
      end    
      before :each do
        show_session_invalid
      end
      it_should_behave_like 'responds with 401 unauthorized'
    end
  end

  #TODO - make this valid for all formats
  describe 'DESTROY session' do
    context 'unauthorized user' do
      def invalid_destroy_session
        delete :destroy, id: 111111, format: :json
      end
      before :each do
        invalid_destroy_session
      end
      it_should_behave_like 'responds with 401 unauthorized'
    end    
    context 'authorized user' do
      def destroy_session
        delete :destroy, id: @user.id, format: :json
      end
      before :each do
        login_user
        destroy_session
      end
      it_should_behave_like 'responds with success 200 status code'
    end
  end  
end
