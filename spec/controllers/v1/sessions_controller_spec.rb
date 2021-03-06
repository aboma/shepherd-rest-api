require 'spec_helper'

describe V1::SessionsController, type: :controller do
  include LoginHelper

  # get a valid authorization to use on requests
  before :all do
    create_test_user
  end

  after :all do
    destroy_test_user
  end

  describe 'CREATE session' do   
    def post_create_session(args)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      post :create, user: { email: args[:email], password: args[:pw] }, format: args[:format]    
    end
    context 'unauthorized user' do
      context 'HTML or XML format' do                 
        [:xml, :html].each do |format| 
          before :each do
            post_create_session email: @user.email, pw: '#{@pw}sssss', format: format 
          end
          it 'returns not acceptable 406 code for #{format}' do
            response.status.should == 406
          end
        end
      end
      context 'JSON format' do
        context 'with invalid password for JSON' do
          it 'returns 401 unauthorized code' do
            post_create_session email: @user.email, pw: '#{@pw}sssss', format: :json
            response.status.should == 401
          end
        end    
        context 'with valid password' do
          before :each do
            post_create_session email: @user.email, pw: @pw, format: :json
            @body = JSON.parse(response.body) 
          end
          it_should_behave_like 'an action that responds with JSON'       
          it_should_behave_like 'responds with success 201 status code'
          it 'returns two fields' do
            @body['session'].should have(2).items          
          end
          it 'returns success message' do
            @body['session']['success'].should be_true
          end
          it 'returns authentication token' do
            @body['session']['auth_token'].should be_present
          end
        end
      end
    end
  end

  describe 'SHOW session' do
    context 'authorized user' do
      def show_session
        request.env['devise.mapping'] = Devise.mappings[:user]
        request.env['X-AUTH-TOKEN'] = @auth_token
        get :show, id: @auth_token, format: :json
      end      
      it 'returns 200 success code' do
        show_session
        response.status.should == 200
      end
    end

    context 'unauthorized user' do
      def show_session_invalid
        request.env['devise.mapping'] = Devise.mappings[:user]
        get :show, id: 1111111, format: :json
      end    
      it 'returns 401 unauthorized' do
        show_session_invalid
        response.status.should == 401
      end
    end
  end

  #TODO - make this valid for all formats
  describe 'DESTROY session' do
    context 'unauthorized user' do
      def invalid_destroy_session
        request.env['devise.mapping'] = Devise.mappings[:user]
        delete :destroy, id: @auth_token, format: :json
      end
      it 'returns 401 unauthorized code' do
        invalid_destroy_session
        response.status.should == 401
      end
    end    
    context 'authorized user' do
      def destroy_session
        request.env['devise.mapping'] = Devise.mappings[:user]
        request.env['X-AUTH-TOKEN'] = @auth_token
        delete :destroy, id: @auth_token, format: :json
      end
      it 'returns success code' do
        destroy_session
        response.status.should == 200
      end
      it 'changes users authorization code' do
        destroy_session
        @changed_user = V1::User.find_by_id(@user.id)
        @changed_user.authentication_token.should_not == @user.authentication_token
      end
    end
  end  
end
