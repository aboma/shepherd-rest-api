require 'spec_helper'

describe V1::SessionsController, :type => :controller do

  get_auth_token
  
  describe "CREATE session" do   
    def post_create_session(args)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      post :create, :user => { :email => args[:email], :password => args[:pw] }, :format => args[:format]    
    end
    context "unauthorized user" do
      context "with invalid password for JSON" do
        it "returns 401 unauthorized code" do
          post_create_session :email => @user.email, :pw => "#{@pw}sssss", :format => :json
          response.status.should == 401
        end
        
        [:xml, :html].each do |format| 
          before :each do
            post_create_session :email => @user.email, :pw => "#{@pw}sssss", :format => format 
          end
          it "returns unauthorized 406 code for #{format}" do
            response.status.should == 406
          end
        end
      end    
      context "with valid password" do
        before :each do
          post_create_session :email => @user.email, :pw => @pw, :format => :json
          @body = JSON.parse(response.body) 
        end
        it "returns success code" do
          response.status.should == 200
        end
        it "returns two fields" do
          @body['session'].should have(2).items          
        end
        it "returns success message" do
          @body['session']['success'].should be_true
        end
        it "returns authentication token" do
          @body['session']['auth_token'].should be_present
        end
      end
    end
  end
  
  describe "DESTROY session" do
    context "unauthorized user" do
      pending
    end    
    context "authorized user" do
      def destroy_session
        request.env["devise.mapping"] = Devise.mappings[:user]
        request.env['X-AUTH-TOKEN'] = @auth_token
        delete :destroy, :id => @auth_token, :format => :json
        @parsed = JSON.parse(response.body)
      end
      it "returns success code" do
        destroy_session
        response.status.should == 200
      end
      it "changes user's authorization code" do
        destroy_session
        @changed_user = User.find_by_id(@user.id)
        @changed_user.authentication_token.should_not == @user.authentication_token
      end
    end
  end  
end