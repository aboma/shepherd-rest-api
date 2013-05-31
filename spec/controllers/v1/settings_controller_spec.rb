require 'spec_helper'

describe V1::SettingsController, :type => :controller do
  include LoginHelper

  # get a valid authorization to use on requests
  before :all do
    create_test_user
  end

  after :all do
    destroy_test_user
  end

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
          it "returns 406 code for format #{format}" do
            response.status.should == 406  
          end
        end
      end
      context "with JSON format" do
        it_should_behave_like "JSON controller index action"        
      end
    end
  end

  describe "get SHOW" do
    context "with valid authorization token" do
      def get_setting(format)
        request.env['X-AUTH-TOKEN'] = @auth_token
        get :show, :id => 1, :format => format
        @parsed = JSON.parse(response.body)
      end
      context "with XML or HTML format" do
        [:xml, :html].each do |format|
          before :each do
            get_setting(format) 
          end
          it "should return 406 code for format #{format}" do
            response.status.should == 406  
          end
        end
      end
      context "with JSON format" do
        before :each do
          get_setting(:json)
        end
        it "returns 405 method not allowed error" do
          response.status.should == 405
        end
      end
    end
  end

  describe "post CREATE" do
    it_should_behave_like "a protected action" do
      let(:data) { "" }
      def action(args_hash)
        post :create, :setting => args_hash[:data], :format => args_hash[:format] 
      end   
    end

    context "with valid authorization token" do 
      def post_setting attrs, format
        request.env['X-AUTH-TOKEN'] = @auth_token
        post :create, :setting => attrs, :format => format 
      end  
      context "with XML or HTML format" do
        [:xml, :html].each do |format|
          before :each do
            post_setting({}, format)        
          end
          it "should return 406 code for format #{format}" do
            response.status.should == 406  
          end
        end          
      end    
      context "with JSON format" do   
        before :each do
          post_setting({}, :json)
        end
        it "returns 405 method not allowed error" do
          response.status.should == 405
        end
      end
    end
  end

  ### post UPDATE =========================================================
  describe "post UPDATE" do
    it_should_behave_like "a protected action" do
      let(:data) { "" }
      def action(args_hash)
        post :update, :id => 1, :setting => args_hash[:data], :format => args_hash[:format] 
      end   
    end

    context "with valid authorization token" do
      def post_update_setting id, attrs, format
        request.env['X-AUTH-TOKEN'] = @auth_token
        post :update, :id => id, :setting => attrs, :format => format 
      end  
      context "with XML or HTML format" do
        [:xml, :html].each do |format|
          before :each do
            post_update_setting(1, {}, format)
          end
          it_should_behave_like "an action that responds with JSON"       
          it "returns 406 code for format #{format}" do
            response.status.should == 406  
          end
        end          
      end
      context "with JSON format" do
        before :each do
          post_update_setting(1, {}, :json)
        end
        it_should_behave_like "an action that responds with JSON"
        it "returns 405 method not allowed error" do
          response.status.should == 405
        end
      end
    end
  end

  ### DELETE ===============================================
  describe "delete DELETE" do
    context "unauthorized user" do
      it_should_behave_like "a protected action" do 
        let(:id) { 1 }
        def action(args_hash)
          delete :destroy, :id => args_hash[:id] , :format => args_hash[:format] 
        end   
      end
    end         
    context "with valid authorization token" do
      def delete_setting(id, format)
        request.env['X-AUTH-TOKEN'] = @auth_token
        delete :destroy, :id => id, :format => format 
      end
      context "with XML or HTML format" do
        [:xml, :html].each do |format|
          before :each do
            delete_setting(1, format)    
          end
          it_should_behave_like "an action that responds with JSON"       
          it "should return 406 code for format #{format}" do
            response.status.should == 406  
          end
        end          
      end
      context "with JSON format" do
        before :each do
          delete_setting(1, :json)
        end
        it_should_behave_like "an action that responds with JSON"
        it "responds with 405 method not allowed error" do
          response.status.should == 405
        end
      end
    end
  end
end 
