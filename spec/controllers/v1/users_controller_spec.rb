require 'spec_helper'

describe V1::UsersController, :type => :controller do
  include LoginHelper

  # get a valid authorization to use on requests
  before :all do
    create_test_user
  end

  after :all do
    destroy_test_user
  end

  let(:user) { FactoryGirl.create(:v1_user) }

  ### GET INDEX ==================================================
  describe "get INDEX" do
    context "unauthorized user" do
      it_should_behave_like "a protected action" do
        def action(args_hash)
          get :index, :format => args_hash[:format]
        end      
      end 
    end
    context "with valid authorization token" do
      def get_index(format)
        request.env['X-AUTH-TOKEN'] = @auth_token
        get :index, :format => format 
      end
      context "with XML or HTML format" do
        [:xml, :html].each do |format|
          before :each do 
            get_index(format) 
          end
          it "should return 406 code for format #{format}" do
            response.status.should == 406  
          end
        end
      end
      context "with JSON format" do
        it_should_behave_like "JSON controller index action"        
      end
    end
  end

  ### GET SHOW ====================================================
  describe "get SHOW" do
    context "unauthorized user" do
      it_should_behave_like "a protected action" do
        let(:data) { { :id => user.id } }
        def action(args_hash)
          get :show, args_hash[:data], :format => args_hash[:format]
        end
      end
    end
    context "with valid authorization token" do
      context "with valid user id" do
        before :each do
          request.env['X-AUTH-TOKEN'] = @auth_token
          get :show, :id => user.id, :format => :json
          @parsed = JSON.parse(response.body)
        end
        it_should_behave_like "an action that responds with JSON"
        it "responds with the asked for user" do
          @parsed['user']['id'].should == user.id
        end
      end
      context "invalid user id" do
        before :each do
          request.env['X-AUTH-TOKEN'] = @auth_token
          get :show, :id => user.id + 1111, :format => :json
          @parsed = JSON.parse(response.body)
        end
        it_should_behave_like "an action that responds with JSON"
        it "responds with 404 not found" do
          response.status.should == 404
        end
      end
    end
  end

  describe "post CREATE" do
    it_should_behave_like "a protected action" do
      let(:data) { FactoryGirl.attributes_for(:v1_user) }
      def action(args_hash)
        post :create, :user => args_hash[:data], :format => args_hash[:format] 
      end   
    end

    context "with valid authorization token" do 
      def post_user attrs, format
        request.env['X-AUTH-TOKEN'] = @auth_token
        post :create, :user => attrs, :format => format 
      end  
      context "with XML or HTML format" do
        [:xml, :html].each do |format|
          before :each do
            post_user(FactoryGirl.attributes_for(:v1_user), format)        
          end
          it "should return 406 code for format #{format}" do
            response.status.should == 406  
          end
          it "does not create the user" do
            expect{ 
              post_user(FactoryGirl.attributes_for(:v1_user), format)
            }.to_not change(V1::User, :count)
          end
        end          
      end    
      context "with JSON format" do    
        context "with invalid attributes" do
          let(:valid_attrs) { FactoryGirl.attributes_for(:v1_user) }
          let(:dup_attrs) {
            attrs = FactoryGirl.attributes_for(:v1_user)
            attrs[:email] = valid_attrs[:email]
            attrs
          }
          before :each do
            FactoryGirl.create(:v1_user, valid_attrs)
          end
          it "does not create an user" do
            expect{ 
              post_user(dup_attrs, :json)
            }.to_not change(V1::User, :count)
          end
          it "responds with 409 conflict" do
            post_user(dup_attrs, :json)
            response.status.should == 409
          end
        end
        context "missing required attributes" do
          let(:valid_attrs) { FactoryGirl.attributes_for(:v1_user) }
          let(:invalid_attrs) { 
            valid_attrs.delete(:email)
            valid_attrs
          }
          it "does not create an user" do
            expect{ 
              post_user(invalid_attrs, :json)
            }.to_not change(V1::User, :count)
          end
          #subject {}
          it "responds with 422 unprocessable entity" do
            post_user(invalid_attrs, :json)
            response.status.should == 422
          end
        end

        context "with valid attributes" do
          it "creates one user" do   
            expect{ 
              post_user(FactoryGirl.attributes_for(:v1_user), :json)
            }.to change(V1::User, :count).by(1)
          end 
          before :each do
            post_user(FactoryGirl.attributes_for(:v1_user), :json)
          end
          it_should_behave_like "an action that responds with JSON"       
          it "responds with success 200 status code" do
            response.status.should == 200       
          end
          it "responds with Location header" do
            response.header['Location'].should be_present
          end
        end
      end
    end
  end

  ### put UPDATE =========================================================
  describe "put UPDATE" do
    it_should_behave_like "a protected action" do
      let(:data) { FactoryGirl.attributes_for(:v1_user) }
      def action(args_hash)
        post :update, :id => user.id, :user => args_hash[:data], :format => args_hash[:format] 
      end   
    end

    context "with valid authorization token" do
      def update_user attrs, format
        request.env['X-AUTH-TOKEN'] = @auth_token
        post :update, :id => user.id, :user => attrs, :format => format 
      end  
      context "with XML or HTML format" do
        [:xml, :html].each do |format|
          before :each do
            update_user( { :name => 'new name' } , format)
          end
          it_should_behave_like "an action that responds with JSON"       
          it "returns 406 code for format #{format}" do
            response.status.should == 406  
          end
        end          
      end
      context "JSON format" do
        context "valid input" do
          before :each do
            update_user({ :name => 'new name' }, :json)
            @parsed = JSON.parse(response.body)
          end
          it_should_behave_like "an action that responds with JSON"
          it "returns 200 success status code" do
            response.status.should == 200
          end
          it "returns the updated field" do
            @parsed['user']['id'].should == user.id
          end
        end
        context "invalid input" do
          describe "invalid user id" do
            it "returns status code 404 not found" do
              user.id = '111111'   # change user id to one that does not exist
              update_user({ :name => 'new name' }, :json)
              response.status.should == 404
            end
          end
          describe "already existing user email" do
            it "returns status 409 conflict" do
              existing_user = FactoryGirl.create(:v1_user)
              update_user( { :email => existing_user.email.upcase }, :json )
              response.status.should == 409
            end
          end
        end
      end
    end
  end



end
