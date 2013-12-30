require 'spec_helper'

describe V1::AssetsController, type: :controller do
  include LoginHelper

  # get a valid authorization to use on requests
  before :all do
    create_test_user
  end

  after :all do
    destroy_test_user
  end

    # global helper methods
  let(:portfolio) { FactoryGirl.create(:v1_portfolio) }
  let(:asset) { FactoryGirl.create(:v1_asset) }
  let(:relationship) { create_relationship }

  def relationship_attrs
    attrs = FactoryGirl.attributes_for(:v1_relationship)
    attrs[:asset_id] = asset.id 
    attrs[:portfolio_id] = portfolio.id
    FactoryGirl.attributes_for(:v1_relationship, attrs)
  end 

  def create_relationship
    attrs = relationship_attrs
    FactoryGirl.create(:v1_relationship, attrs)
  end

  # create metadatum values with either valid or invalid data, depending
  # on input to method
  def given_metadata_attrs_with(state)
    metadatum = FactoryGirl.attributes_for(:v1_metadatum_value)
    field = FactoryGirl.create(:v1_metadatum_field)
    metadatum[:metadatum_field_id] = field.id
    if (state) 
      metadatum[:metadatum_field_id] = 99999 if state == :invalid_field
      metadatum[:metadatum_value] = nil if state == :blank_value
      if (state == :invalid_boolean_value)
        field.type = 'boolean'
        field.save!
        metadatum[:metadatum_value] = 'not boolean'
      end
    end
    attrs = { metadata: [ metadatum ] }
    yield attrs
  end

  # create asset with valid or invalid metadata, depending upon options
  # input
  def given_asset_attrs_with(options)
    attrs = []
    if (options[:invalid_field]) 
      metadatum = FactoryGirl.attributes_for(:v1_metadatum_value)
      metadatum[:metadatum_field_id] = 9999
      attrs = { metadata: [ metadatum ] }
    end
    if (options[:valid_metadata])
      metadatum = FactoryGirl.attributes_for(:v1_metadatum_value)
      attrs = { metadata: [ metadatum ] }
    end
    if (options[:blank_metadatum])
      metadatum = FactoryGirl.attributes_for(:v1_metadatum_value)
      metadatum[:metadatum_value] = nil
      attrs = { metadata: [ metadatum ] }
    end
    if (options[:invalid_metadata_value])
      metadatum = FactoryGirl.attributes_for(:v1_metadatum_value, { type: :boolean })
      metadatum[:metadatum_value] = 'notaboolean'
      attrs = { metadata: [ metadatum ] }
    end
    yield FactoryGirl.attributes_for(:v1_asset, attrs)
  end


  ### GET INDEX ==================================================
  describe 'get INDEX' do
    it_should_behave_like 'a protected action' do
      def action(args_hash)
        get :index, format: args_hash[:format]
      end
    end

    context 'with valid authorization token' do
      it_should_behave_like 'JSON controller index action'
      context 'given portfolio id' do
        it 'should return assets for that portfolio' do
          ass = FactoryGirl.create(:v1_asset)
          port = FactoryGirl.create(:v1_portfolio)
          rel_attrs = FactoryGirl.attributes_for(:v1_relationship)
          rel_attrs[:portfolio_id] = port.id
          rel_attrs[:asset_id] = ass.id
          FactoryGirl.create(:v1_relationship, rel_attrs)
          # create another relationship
          rel2 = create_relationship
          request.env['X-AUTH-TOKEN'] = @auth_token
          get :index, portfolio_id: portfolio.id, format: :json
          parsed = JSON.parse(response.body)
          # make sure only second relationship is returned
          parsed['assets'].length.should == 1
          parsed['assets'][0]["id"].should == rel2.asset_id
        end
      end
    end
  end

  ### GET SHOW ===================================================
  describe 'get SHOW' do   
    context 'unauthorized user' do
      it_should_behave_like 'a protected action' do
        let(:data) { { id: asset.id } }
        def action(args_hash)
          get :show, args_hash[:data], format: args_hash[:format]
        end      
      end
    end
    context 'with valid authorization token' do
      context 'valid asset id' do
        before :each do
          request.env['X-AUTH-TOKEN'] = @auth_token
          get :show, id: asset.id, format: :json
          @parsed = JSON.parse(response.body)
        end
        it_should_behave_like 'an action that responds with JSON'
        it 'responds with the asked for asset' do
          @parsed['asset']['id'].should == asset.id
        end 
      end
      context 'invalid asset id' do
        before :each do
          request.env['X-AUTH-TOKEN'] = @auth_token
          get :show, id: asset.id + 111, format: :json
          @parsed = JSON.parse(response.body)
        end
        it_should_behave_like 'an action that responds with JSON'
        it_should_behave_like 'responds with 404 not found'
      end 
    end
  end

  ### POST CREATE ========================================================
  describe 'post CREATE' do
    it_should_behave_like 'a protected action' do
      let(:data) { FactoryGirl.attributes_for(:v1_asset) }
      def action(args_hash)
        post :create, asset: args_hash[:data], format: args_hash[:format] 
      end   
    end

    context 'with valid authorization token' do 
      def post_asset attrs, format
        request.env['X-AUTH-TOKEN'] = @auth_token
        post :create, asset: attrs, format: format 
      end  
      context 'with XML or HTML format' do
        [:xml, :html].each do |format|
          before :each do
            post_asset(FactoryGirl.attributes_for(:v1_asset), format)          
          end
          it "should return 406 code for format #{format}" do
            expect(response.status).to eq(406)
          end
          it 'does not create the asset' do
            expect do 
              post_asset(FactoryGirl.attributes_for(:v1_asset), format)
            end.to_not change(V1::Asset, :count)
          end
        end          
      end    
      context 'with JSON format' do    
        context 'with invalid attributes' do
          context 'duplicate name' do
            let!(:existing_asset) { FactoryGirl.create(:v1_asset) }
            let(:invalid_attrs) do
              attrs = FactoryGirl.attributes_for(:v1_asset)
              attrs[:name] = existing_asset.name
              attrs
            end
            it 'does not create the asset' do
              expect do 
                post_asset(invalid_attrs, :json)
              end.to_not change(V1::Asset, :count)
            end
            it 'return 409 conflict' do
              post_asset(invalid_attrs, :json)
              expect(response.status).to eq(409)
            end
          end
          context 'invalid metadata field' do
            it 'does not create the asset' do
              expect do
                given_asset_attrs_with({ invalid_field: true }) do |invalid_attrs|
                  post_asset(invalid_attrs, :json)
                end
              end.to_not change(V1::Asset, :count)
            end
            it 'gives error messages' do
              given_asset_attrs_with({ invalid_field: true }) do |invalid_attrs|
                post_asset(invalid_attrs, :json)
              end
              parsed = JSON.parse(response.body)
              parsed['errors']['metadata'][0]['metadatum_field_id'].should == ['does not exist']
            end
          end
        end
        context 'missing required attributes' do
          let(:valid_attrs) { FactoryGirl.attributes_for(:v1_asset) }
          let(:invalid_attrs) { 
            valid_attrs.delete(:name)
            valid_attrs
          }
          it 'does not create an asset' do
            expect do 
              post_asset(invalid_attrs, :json)
            end.to_not change(V1::Asset, :count)
          end
          it 'responds with 422 unprocessable entity' do
            post_asset(invalid_attrs, :json)
            expect(response.status).to eq(422)
          end
        end

        context 'with valid attributes' do
          it 'creates one asset' do   
            expect do
              post_asset(FactoryGirl.attributes_for(:v1_asset), :json)
            end.to change(V1::Asset, :count).by(1)
          end
          it 'creates associated metadata values' do
            pending
            #expect do
            #  given_asset_attrs_with({ valid_metadata: true }) do |attrs|
            #    post_asset(attrs, :json)
            #  end
            #end.to change(V1::Asset, :count).by(1)
          end
          before :each do
            post_asset(FactoryGirl.attributes_for(:v1_asset), :json)
          end
          it_should_behave_like 'an action that responds with JSON'       
          it_should_behave_like 'responds with success 201 status code'
          it_should_behave_like 'responds with Location header'
        end
      end
    end
  end

  ### PUT UPDATE ========================================================
  describe 'put UPDATE' do
    it_should_behave_like 'a protected action' do
      let(:data) { FactoryGirl.attributes_for(:v1_asset) }
      def action(args_hash)
        put :update, id: asset.id, relationship: args_hash[:data], format: args_hash[:format] 
      end   
    end

    context 'authorized user' do
      let!(:existing_asset) { asset } 
      let!(:existing_asset_with_metadata) do
        new_asset = FactoryGirl.create(:v1_asset)
        given_metadata_attrs_with(:valid) do |attrs|
          metadatum = FactoryGirl.build(:v1_metadatum_value, attrs[:metadata][0])
          new_asset.metadata << metadatum
          new_asset.save!
        end
        new_asset
      end
      def update_asset(id, attrs, format)
        request.env['X-AUTH-TOKEN'] = @auth_token
        put :update, id: id, asset: attrs, format: format 
      end
      context 'HTML or XML format' do
        [:html, :xml].each do |format|
          before :each do
            update_asset(existing_asset.id, { description: :boom }, format )
          end
          it 'returns 406 not acceptable code' do
            response.status.should == 406
          end
        end
      end
      context 'with JSON format' do
        context 'with invalid attributes' do
          context 'blank metadatum value' do
            it 'does not create metadatum' do
              expect do
                given_metadata_attrs_with(:blank_value) do |attrs|
                  update_asset(existing_asset.id, attrs, :json)
                end
              end.to_not change(V1::MetadatumValue, :count)
            end
            it 'returns unprocessable entity' do
              given_metadata_attrs_with(:blank_value) do |attrs|
                update_asset(existing_asset.id, attrs, :json)
              end
              expect(response.status).to eq(422)
            end
            it 'returns metadata cant be blank message' do
              given_metadata_attrs_with(:blank_value) do |attrs|
                update_asset(existing_asset.id, attrs, :json)
              end
              msg = JSON.parse(response.body)
              msg['errors']['metadata'][0]['metadatum_value'].should == ['can\'t be blank']
            end
          end
          context 'invalid boolean metadata value' do
            it 'returns unprocessable entity' do
              given_metadata_attrs_with(:invalid_boolean_value) do |attrs|
                update_asset(existing_asset.id, attrs, :json)
              end
              expect(response.status).to eq(422)
            end
            it 'returns invalid metadatum value message' do
              given_metadata_attrs_with(:invalid_boolean_value) do |attrs|
                update_asset(existing_asset.id, attrs, :json)
              end
              msg = JSON.parse(response.body)
              msg['errors']["metadata"][0]["metadatum_value"][0].should =~ /invalid boolean value.*/
            end
          end
          context 'invalid metadata field' do
            it 'does not create the metadatum value' do
              expect do
                given_metadata_attrs_with(:invalid_field) do |invalid_attrs|
                  update_asset(existing_asset.id, invalid_attrs, :json)
                end
              end.to_not change(V1::MetadatumValue, :count)
            end
            it 'returns unprocessable entity' do
              given_metadata_attrs_with(:invalid_field) do |attrs|
                update_asset(existing_asset.id, attrs, :json)
              end
              expect(response.status).to eq(422)
            end
            it 'gives error messages' do
              given_metadata_attrs_with(:invalid_field) do |attrs|
                update_asset(existing_asset.id, attrs, :json)
              end
              parsed = JSON.parse(response.body)
              parsed['errors']['metadata'][0]['metadatum_field_id'].should == ['does not exist']
            end
          end
        end
        context 'with valid attributes' do
          it 'does not creates an asset' do   
            expect do
              update_asset(existing_asset.id, { name: 'newname' }, :json)
            end.to_not change(V1::Asset, :count)
          end
          it 'creates new associated metadata values if specified' do
            expect do
              given_metadata_attrs_with(:valid) do |attrs|
                update_asset(existing_asset.id, attrs, :json)
              end
            end.to change(V1::MetadatumValue, :count).by(1)
          end
          it 'removes existing metadata values if specified' do
            expect do
              update_asset(existing_asset_with_metadata.id, { metadata: [] }, :json)
            end.to change(V1::MetadatumValue, :count).by(-1)
          end
          it 'updates existing metadata values if specified' do
            new_value = 'this is the new md value'
            attrs = existing_asset_with_metadata.attributes
            attrs[:metadata] =  [ existing_asset_with_metadata.metadata[0].attributes ]
            attrs[:metadata][0][:metadatum_value] = new_value
            update_asset(existing_asset_with_metadata.id, attrs, :json)
            json = JSON.parse(response.body)
            json['asset']['metadata'][0]['metadatum_value'].should == new_value
          end
          before :each do
            update_asset(existing_asset.id, { name: 'newname' }, :json)
          end
          it_should_behave_like 'an action that responds with JSON'       
          it_should_behave_like 'responds with success 200 status code'
        end
      end
    end
  end

  describe 'delete DELETE' do
    pending
  end
end
