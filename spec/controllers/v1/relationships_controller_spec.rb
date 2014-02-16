require 'spec_helper'

describe V1::RelationshipsController, type: :controller do
  include LoginHelper

  def given_relation_attrs_with(options)
    attrs = FactoryGirl.attributes_for(:v1_relationship)
    attrs[:asset_id] = FactoryGirl.create(:v1_asset).id if options[:valid_asset]
    attrs[:asset_id] = '12345' unless options[:valid_asset]
    attrs[:portfolio_id] = FactoryGirl.create(:v1_portfolio).id if options[:valid_portfolio]
    attrs[:portfolio_id] = '12345' unless options[:valid_portfolio]
    yield attrs
  end

  let(:relation) do 
    given_relation_attrs_with({ valid_asset: true, valid_portfolio: true}) do |attrs|
      return FactoryGirl.create(:v1_relationship, attrs) 
    end
  end 

  ### GET INDEX ==================================================
  describe 'get INDEX' do
    context 'unauthorized user' do
      it_should_behave_like 'a protected action' do
        def action(args_hash)
          get :index, format: args_hash[:format]
        end      
      end 
    end
    context 'with valid authorization token' do
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
        describe 'with a portfolio_id as a query parameter' do
          it 'returns relationships filtered by portfolio id' do
            pending
          end
        end
      end
    end
  end

  ### GET SHOW ==========================================================
  describe 'get SHOW' do
    context 'unauthorized user' do
      it_should_behave_like 'a protected action' do
        let(:data) { { id: relation.id } }
        def action(args_hash)
          get :show, args_hash[:data], format: args_hash[:format]
        end      
      end 
    end

    context 'with valid authorization token' do
      def get_relation(format)
        login_user
        get :show, id: relation.id, format: format
      end
      context 'with XML or HTML format' do
        [:xml, :html].each do |format|
          before :each do
            get_relation(format) 
          end
          it_should_behave_like 'responds with 406 not acceptable'
        end
      end
      context 'with JSON format' do
        context 'valid relationship id' do
          before :each do
            get_relation(:json) 
          end
          it_should_behave_like 'an action that responds with JSON'
          it_should_behave_like 'responds with success 200 status code'
          it 'responds with the asked for portfolio' do
            @parsed = JSON.parse(response.body)
            @parsed['relationship']['id'].should == relation.id
          end
        end
        context 'valid asset and portfolio ids' do
          pending
        end
        context 'invalid relationship id' do
          before :each do
            relation.id += 5
            login_user
            get :show, id: relation.id, format: :json
            @parsed = JSON.parse(response.body)
          end
          it_should_behave_like 'responds with 404 not found'
          it 'responds with error message' do
            @parsed['errors']['id'].should == 'relationship not found'
          end
        end
    end
    end
  end

  ### POST CREATE ========================================================
  describe 'post CREATE' do
    it_should_behave_like 'a protected action' do
      let(:data) { FactoryGirl.attributes_for(:v1_relationship) }
      def action(args_hash)
        post :create, relationship: args_hash[:data], format: args_hash[:format] 
      end   
    end

    context 'with valid authorization token' do 
      def post_relation attrs, format        
        login_user
        post :create, relationship: attrs, format: format 
      end
      # create action accepts all formats to make it easier to 
      # post files
      context 'with XML or HTML format' do
        [:xml, :html].each do |format|
          before :each do
            given_relation_attrs_with({ valid_asset: true, valid_portfolio: true}) do |attrs|
               post_relation(attrs, :json)
            end        
          end
          it_should_behave_like 'responds with success 201 status code'
        end          
      end
      context 'with JSON format' do
        context 'with valid attributes' do
          it 'increases number of relationships by 1' do   
            expect do
              given_relation_attrs_with({ valid_asset: true, valid_portfolio: true}) do |attrs|
                 post_relation(attrs, :json)
              end
            end.to change(V1::Relationship, :count).by(1)
          end    

          before :each do
            given_relation_attrs_with({ valid_asset: true, valid_portfolio: true}) do |attrs|
               post_relation(attrs, :json)
            end
          end
          it_should_behave_like 'an action that responds with JSON'       
          it_should_behave_like 'responds with success 201 status code'
          it_should_behave_like 'responds with Location header'
        end
        context 'with invalid attributes' do
          context 'portfolio does not exist' do
            it 'does not increase the number of relationships' do   
              expect do
                given_relation_attrs_with({ valid_asset: true, valid_portfolio: false}) do |attrs|
                   post_relation(attrs, :json)
                end
              end.to_not change(V1::Relationship, :count)
            end
            before :each do
              given_relation_attrs_with({ valid_asset: true, valid_portfolio: false}) do |attrs|
                 post_relation(attrs, :json)
              end
            end
            it_should_behave_like 'an action that responds with JSON'       
            it_should_behave_like 'responds with 422 unprocessable entity'
            it 'responds with missing portfolio error' do
              parsed = JSON.parse(response.body)
              parsed['errors']['id'].should =~ /portfolio with id \d+ not found/
            end
          end
          context 'asset does not exist' do
            it 'does not increase the number of relationships' do   
              expect do
                given_relation_attrs_with({ valid_asset: false, valid_portfolio: true}) do |attrs|
                   post_relation(attrs, :json)
                end
              end.to_not change(V1::Relationship, :count)
            end
            before :each do
              given_relation_attrs_with({ valid_asset: false, valid_portfolio: true}) do |attrs|
                 post_relation(attrs, :json)
              end
            end
            it_should_behave_like 'an action that responds with JSON'       
            it_should_behave_like 'responds with 422 unprocessable entity'
            it 'responds with missing portfolio error' do
              parsed = JSON.parse(response.body)
              parsed['errors']['id'].should =~ /asset with id \d+ not found/
            end
          end
          context 'relationship already exists between asset and portfolio' do
            before :each do
              given_relation_attrs_with({ valid_asset: true, valid_portfolio: true}) do |attrs|
                 post_relation(attrs, :json)
                 post_relation(attrs, :json)
              end
            end
            it_should_behave_like 'an action that responds with JSON'       
            it_should_behave_like 'responds with 422 unprocessable entity'
            it 'responds with missing portfolio error' do
              parsed = JSON.parse(response.body)
              parsed['errors']['id'].should =~ /relationship already exists/
            end
          end
        end
      end
    end
  end

  ### post UPDATE =========================================================
  describe 'put UPDATE' do
    it_should_behave_like 'a protected action' do
      let(:data) { FactoryGirl.attributes_for(:v1_relationship) }
      def action(args_hash)
        put :update, id: relation.id, relationship: args_hash[:data], format: args_hash[:format] 
      end   
    end

    context 'with valid authorization token' do
      def update_relation id, attrs, format
        login_user
        post :update, id: id, relationship: attrs, format: format 
      end  
      context 'with XML or HTML format' do
        [:xml, :html].each do |format|
          before :each do
             given_relation_attrs_with({ valid_asset: true, valid_portfolio: true}) do |attrs|
               update_relation(relation.id, attrs, format)
             end        
          end
          it_should_behave_like 'responds with 406 not acceptable'
        end          
      end
      # Updating a relationship should not be possible: only create and delete
      context 'with JSON format' do
        before :each do
          given_relation_attrs_with({ valid_asset: true, valid_portfolio: true}) do |attrs|
            update_relation(relation.id, attrs, :json)
          end
        end
        it_should_behave_like 'an action that responds with JSON'
        it_should_behave_like 'responds with 422 unprocessable entity'
      end
    end
  end

  ### DELETE ===============================================
  describe 'delete DELETE' do
    let!(:rel) { relation }
    context 'unauthorized user' do
      it_should_behave_like 'a protected action' do 
        let(:id) { relation.id }
        def action(args_hash)
          delete :destroy, id: args_hash[:id], format: args_hash[:format] 
        end   
      end
    end         
    context 'with valid authorization token' do
      def delete_relation(id, format)
        login_user
        delete :destroy, id: id, format: format 
      end
      context 'with XML or HTML format' do
        [:xml, :html].each do |format|
          it 'does not change the number of relationships' do   
            expect do
              delete_relation(rel.id, format)
            end.to_not change(V1::Relationship, :count)
          end
          before :each do
            delete_relation(rel.id, format)    
          end
          it_should_behave_like 'responds with 406 not acceptable'
        end          
      end
      context 'with JSON format' do
        it 'decreases number of relationships by 1' do   
          expect do 
            delete_relation(rel.id, :json)
          end.to change(V1::Relationship, :count).by(-1)
        end
        it 'should respond with JSON' do
          delete_relation(rel.id, :json)
          response.header['Content-Type'].should include 'application/json'          
        end
        it 'responds with success 200 status code' do
          delete_relation(rel.id, :json)
          response.status.should == 200       
        end
      end
    end
  end
end
