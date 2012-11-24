require 'spec_helper'

describe V1::SessionsController, :type => :controller do

  create_user
  
  describe "create session" do   
    context "unauthorized user" do
      context "with invalid password" do
        [:json, :xml, :html].each do |format| 
          before :each do
            @request.env["devise.mapping"] = Devise.mappings[:user]
            post :create, :user => { :email => @user.email, :password => "#{@pw}sss" }, :format => :json 
          end
          it "returns unauthorized 401 code for #{format}" do
            response.status.should == 401
          end
        end
      end    
      context "with valid password" do
        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:user]
          post :create, :user => { :email => @user.email, :password => @pw } , :format => :json
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
  
  describe "destroy" do
    context "unauthorized user" do
      pending
    end    
  end  
end