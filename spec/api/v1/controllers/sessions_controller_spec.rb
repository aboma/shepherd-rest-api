require 'spec_helper'

describe V1::SessionsController, :type => :controller do

  create_user
  
  describe "create" do
    
    context "unauthorized user" do
      context "with invalid password" do
        [:json, :xml, :html].each do |format| 
          before :each do
            @request.env["devise.mapping"] = Devise.mappings[:user]
            post :create, { :user => { :email => @user.email, :password => "#{@user.password}sss" } }, :format => :json 
          end
          it "returns unauthorized 401 code for #{format}" do
            response.status = 401
          end
        end
      end
      
      context "with valid password" do
        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:user]
          post :create, { :user => { :email => @user.email, :password => @user.password } }, :format => :json  
        end
        it "returns success code" do
          response.status == 200
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