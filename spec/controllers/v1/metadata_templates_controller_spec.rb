require 'spec_helper'

describe V1::MetadataTemplatesController, type: :controller do
  include LoginHelper

  before :all do 
    create_test_user
  end

  after :all do
    destroy_test_user
  end

  def given_template(options)
    template = FactoryGirl.create(:v1_metadata_template)
    if options && options[:field_settings]
      field = FactoryGirl.create(:v1_metadatum_field)     
      FactoryGirl.create(:v1_template_field_setting, 
                         { metadatum_field_id: field.id, required: true, order: 1, 
                           metadata_template_id: template.id })
    end
    template.reload
    template
  end

  let(:template) { FactoryGirl.create(:v1_metadata_template) }

  ### get INDEX ========================================================
  describe 'get INDEX' do
    it_should_behave_like 'a protected action' do
      def action(args_hash)
        get :index, format: args_hash[:format]
      end
    end

    context 'with valid authorization token' do
      it_should_behave_like 'JSON controller index action'
    end
  end

  ### get SHOW ========================================================
  describe 'get SHOW' do
    context 'unauthorized user' do
      it_should_behave_like 'a protected action' do
        let(:data) { { id: template.id } }
        def action(args_hash)
          get :show, args_hash[:data], format: args_hash[:format]
        end
      end
    end
    context 'with valid authorization token' do
      context 'with valid template id' do
        before :each do
          request.env['X-AUTH-TOKEN'] = @auth_token
          get :show, id: template.id, format: :json
          @parsed = JSON.parse(response.body)
        end
        it_should_behave_like 'an action that responds with JSON'
        it 'responds with the asked for template' do
          @parsed['metadata_template']['id'].should == template.id
        end
      end
      context 'invalid template id' do
        before :each do
          request.env['X-AUTH-TOKEN'] = @auth_token
          get :show, id: template.id + 111, format: :json
        end
        it_should_behave_like 'an action that responds with JSON'
        it 'responds with 404 not found' do
          response.status.should == 404
        end
      end
    end
  end

  ### post CREATE ========================================================
  describe 'post CREATE' do
    it_should_behave_like 'a protected action' do
      let(:data) { FactoryGirl.attributes_for(:v1_metadata_template) }
      def action(args_hash)
        post :create, metadata_template: args_hash[:data], format: args_hash[:format] 
      end   
    end

    context 'with valid authorization token' do 
      def post_template attrs, format
        request.env['X-AUTH-TOKEN'] = @auth_token
        post :create, metadata_template: attrs, format: format 
      end  
      context 'with XML or HTML format' do
        [:xml, :html].each do |format|
          before :each do
            post_template(FactoryGirl.attributes_for(:v1_metadata_template), format)        
          end
          it "should return 406 code for format #{format}" do
            response.status.should == 406  
          end
          it 'does not create the template' do
            expect do 
              post_template(FactoryGirl.attributes_for(:v1_metadata_template), format)
            end.to_not change(V1::MetadataTemplate, :count)
          end
        end          
      end    
      context 'with JSON format' do    
        context 'with invalid attributes' do
          let(:valid_attrs) { FactoryGirl.attributes_for(:v1_metadata_template) }
          context 'with duplicate name' do
            let(:dup_attrs) do
              attrs = FactoryGirl.attributes_for(:v1_metadata_template)
              attrs[:name] = valid_attrs[:name].upcase
              attrs
            end
            before :each do
              FactoryGirl.create(:v1_metadata_template, valid_attrs)
            end
            it 'does not create an metadata template' do
              expect do 
                post_template(dup_attrs, :json)
              end.to_not change(V1::MetadataTemplate, :count)
            end
            it 'responds with 409 conflict' do
              post_template(dup_attrs, :json)
              response.status.should == 409
            end
          end
        end
        context 'missing required attributes' do
          let(:valid_attrs) { FactoryGirl.attributes_for(:v1_metadata_template) }
          let(:invalid_attrs) { 
            valid_attrs.delete(:name)
            valid_attrs
          }
          it 'does not create an metadata template' do
            expect do
              post_template(invalid_attrs, :json)
            end.to_not change(V1::MetadataTemplate, :count)
          end
          it 'responds with 422 unprocessable entity' do
            post_template(invalid_attrs, :json)
            response.status.should == 422
          end
        end

        context 'with valid attributes' do
          it 'creates one template' do   
            expect do
              post_template(FactoryGirl.attributes_for(:v1_metadata_template), :json)
            end.to change(V1::MetadataTemplate, :count).by(1)
          end 
          before :each do
            post_template(FactoryGirl.attributes_for(:v1_metadata_template), :json)
          end
          it_should_behave_like 'an action that responds with JSON'       
          it_should_behave_like 'responds with success 201 status code'
          it_should_behave_like 'responds with Location header'
          context 'with associated field settings' do
            it 'creates the field settings as well' do
              expect do
                template = FactoryGirl.attributes_for(:v1_metadata_template)
                field = FactoryGirl.create(:v1_metadatum_field)
                settings_hash = [{ metadatum_field_id: field.id, required: false, order: 1}]
                template[:metadata_template_field_settings] = settings_hash
                post_template(template, :json)
              end.to change(V1::MetadataTemplateFieldSetting, :count).by(1)
            end
          end

        end
      end
    end
  end

  ### PUT UPDATE ========================================================
  describe 'put UPDATE' do
    it_should_behave_like 'a protected action' do
      let(:data) { { name: :updated_name } }
      let(:id) { template.id }
      def action(args_hash)
        put :update, id: args_hash[:id], metadata_template: args_hash[:data] , format: args_hash[:format] 
      end   
    end
    context 'authorized user' do
      def update_template(attrs, format)
        request.env['X-AUTH-TOKEN'] = @auth_token
        put :update, id: template.id, metadata_template: attrs, format: format         
      end
      context 'HTML or XML format' do
        [:html, :xml].each do |format|
          before :each do
            update_template({ description: :boom }, format )
          end
          it 'returns 406 not acceptable code' do
            response.status.should == 406
          end
        end
      end
      context 'JSON format' do
        context 'valid input' do
          before :each do
            update_template({ description: :boom }, :json )
            @parsed = JSON.parse(response.body)
          end
          it_should_behave_like 'an action that responds with JSON'
          it 'returns 200 success status code' do
            response.status.should == 200
          end
          it 'returns the updated metadata template' do
            @parsed['metadata_template']['id'].should == template.id
          end
        end
        context 'invalid input' do
          describe 'invalid template id' do
            it 'returns status code 404 not found' do
              template.id = '1111'   # change metadata_template id to one that does not exist
              update_template({ name: 'test' }, :json )
              response.status.should == 404
            end
          end
          describe 'already existing template name' do
            it 'returns status 409 conflict' do
              existing_template = FactoryGirl.create(:v1_metadata_template)
              update_template({ name: existing_template.name.upcase }, :json )
              response.status.should == 409
            end
          end
        end
      end
    end
  end

  ### delete DESTROY =========================================================
  describe 'delete DESTROY' do
    # object must be created outside of the expects statement
    let!(:template_to_delete) { template }
    context 'unauthorized user' do
      it_should_behave_like 'a protected action' do 
        let(:id) { template_to_delete.id }
        def action(args_hash)
          delete :destroy, id: args_hash[:id] , format: args_hash[:format] 
        end   
      end
    end         
    context 'with valid authorization token' do
      def delete_template(id, format)
        request.env['X-AUTH-TOKEN'] = @auth_token
        delete :destroy, id: id, format: format 
      end
      context 'with XML or HTML format' do
        [:xml, :html].each do |format|
          it 'does not change the number of templates' do   
            expect do
              delete_template(template_to_delete.id, format)
            end.to_not change(V1::MetadataTemplate, :count)
          end
          before :each do
            delete_template(template_to_delete.id, format)    
          end
          it "should return 406 code for format #{format}" do
            response.status.should == 406  
          end
        end          
      end
      context 'with JSON format' do
        let!(:template_with_field_settings) do
          given_template({ field_settings: true })
        end
        it 'decreases number of templates by 1' do   
          expect do 
            delete_template(template_with_field_settings.id, :json)
          end.to change(V1::MetadataTemplate, :count).by(-1)
        end
        it 'deletes associated field settings as well' do
          expect do
            delete_template(template_with_field_settings.id, :json)
          end.to change(V1::MetadataTemplateFieldSetting, :count).by(-1)
        end
        it 'should respond with JSON' do
          delete_template(template_with_field_settings.id, :json)
          response.header['Content-Type'].should include 'application/json'          
        end
        it 'responds with success 200 status code' do
          delete_template(template_with_field_settings.id, :json)
          response.status.should == 200       
        end
      end
    end
  end


end
