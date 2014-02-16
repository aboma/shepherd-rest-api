require 'spec_helper'

describe V1::SettingsController, type: :controller do
  include LoginHelper

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
        before :each do 
          get_index(:json) 
        end  
        it_should_behave_like 'responds with 405 method not allowed error'
      end
    end
  end

  ### GET SHOW ==================================================
  describe 'get SHOW' do
    context 'with valid authorization' do
      def get_setting(format)
        login_user
        get :show, id: 1, format: format
      end
      context 'with XML or HTML format' do
        [:xml, :html].each do |format|
          before :each do
            get_setting(format) 
          end
          it_should_behave_like 'responds with 406 not acceptable'
        end
      end
      context 'with JSON format' do
        before :each do
          get_setting(:json)
        end
        it_should_behave_like 'an action that responds with JSON'       
        it_should_behave_like 'responds with success 200 status code'
      end
    end
  end

  ### POST CREATE ===============================================
  describe 'post CREATE' do
    it_should_behave_like 'a protected action' do
      let(:data) { '' }
      def action(args_hash)
        post :create, setting: args_hash[:data], format: args_hash[:format] 
      end   
    end

    context 'with valid authorization' do 
      def post_setting attrs, format
        login_user
        post :create, setting: attrs, format: format 
      end  
      context 'with XML or HTML format' do
        [:xml, :html].each do |format|
          before :each do
            post_setting({}, format)        
          end
          it_should_behave_like 'responds with 406 not acceptable'
        end          
      end    
      context 'with JSON format' do   
        before :each do
          post_setting({}, :json)
        end
        it_should_behave_like 'responds with 405 method not allowed error'
      end
    end
  end

  ### post UPDATE =========================================================
  describe 'post UPDATE' do
    it_should_behave_like 'a protected action' do
      let(:data) { '' }
      def action(args_hash)
        post :update, id: 1, setting: args_hash[:data], format: args_hash[:format] 
      end   
    end

    context 'with valid authorization' do
      def post_update_setting id, attrs, format
        login_user
        post :update, id: id, setting: attrs, format: format 
      end  
      context 'with XML or HTML format' do
        [:xml, :html].each do |format|
          before :each do
            post_update_setting(1, {}, format)
          end
          it_should_behave_like 'responds with 406 not acceptable'
        end          
      end
      context 'with JSON format' do
        before :each do
          post_update_setting(1, {}, :json)
        end
        it_should_behave_like 'an action that responds with JSON'
        it_should_behave_like 'responds with 405 method not allowed error'
      end
    end
  end

  ### DELETE ===============================================
  describe 'delete DELETE' do
    context 'unauthorized user' do
      it_should_behave_like 'a protected action' do 
        let(:id) { 1 }
        def action(args_hash)
          delete :destroy, id: args_hash[:id], format: args_hash[:format] 
        end   
      end
    end         
    context 'with valid authorization' do
      def delete_setting(id, format)
        login_user
        delete :destroy, id: id, format: format 
      end
      context 'with XML or HTML format' do
        [:xml, :html].each do |format|
          before :each do
            delete_setting(1, format)    
          end
          it_should_behave_like 'responds with 406 not acceptable'
        end          
      end
      context 'with JSON format' do
        before :each do
          delete_setting(1, :json)
        end
        it_should_behave_like 'an action that responds with JSON'
        it_should_behave_like 'responds with 405 method not allowed error'
      end
    end
  end
end 
