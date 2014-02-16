require 'spec_helper'

# Uses shared examples to test common controller functionality
# such as authorization. These are located in shared_examples.rb
describe V1::PortfoliosController, type: :controller do
  include LoginHelper

  let(:port) { FactoryGirl.create(:v1_portfolio) }

  ### GET INDEX ==================================================
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

  ### GET SHOW ==========================================================
  describe 'get SHOW' do
    context 'unauthorized user' do
      it_should_behave_like 'a protected action' do
        let(:data) { { id: port.id } }
        def action(args_hash)
          get :show, args_hash[:data], format: args_hash[:format]
        end      
      end 
    end

    context 'with valid authorization token' do
      context 'valid portfolio id' do      
        before :each do
          login_user
          get :show, id: port.id, format: :json
          @parsed = JSON.parse(response.body)
        end
        it_should_behave_like 'an action that responds with JSON'
        it_should_behave_like 'responds with success 200 status code'
        it 'responds with the asked for portfolio' do
          @parsed['portfolio']['id'].should == port.id
        end
        it 'responds with the portfolio name' do
          @parsed['portfolio']['name'].should == port.name
        end
      end
      context 'invalid portfolio id' do
        before :each do
          port.id += 5
          login_user
          get :show, id: port.id, format: :json
        end
        it_should_behave_like 'responds with 404 not found'
      end
    end 
  end

  ### POST CREATE ========================================================
  describe 'post CREATE' do
    it_should_behave_like 'a protected action' do
      let(:data) { FactoryGirl.attributes_for(:v1_portfolio) }
      def action(args_hash)
        post :create, portfolio: args_hash[:data], format: args_hash[:format] 
      end   
    end

    context 'with valid authorization token' do 
      def post_portfolio attrs, format
        login_user
        post :create, portfolio: attrs, format: format 
      end  
      context 'with XML or HTML format' do
        [:xml, :html].each do |format|
          before :each do
            post_portfolio(FactoryGirl.attributes_for(:v1_portfolio), format)          
          end
          it_should_behave_like 'responds with 406 not acceptable'
        end          
      end    
      context 'with JSON format' do    
        context 'without required attributes' do
          before :each do
            post_portfolio({ inv_attr: 'invalid attribute' }, :json)
          end
          it_should_behave_like 'responds with 422 unprocessable entity'
        end
        context 'with invalid attributes' do
          let!(:existing_port) { port }
          let!(:attrs) do
            attrs = FactoryGirl.attributes_for(:v1_portfolio)
            attrs[:name] = existing_port.name
            attrs
          end
          context 'with duplicate name' do
            it 'does not create the portfolio' do
              expect do
                post_portfolio(attrs, :json)
              end.to_not change(V1::Portfolio, :count)
            end
            it 'responds with 409 conflict' do
              post_portfolio(attrs, :json)
              expect(response.status).to eq(409)
            end
          end
        end
        context 'with valid attributes' do
          it 'increases number of portfolios by 1' do   
            expect do
              post_portfolio(FactoryGirl.attributes_for(:v1_portfolio), :json)
            end.to change(V1::Portfolio, :count).by(1)
          end    

          before :each do
             @port_attrs = FactoryGirl.attributes_for(:v1_portfolio)
             post_portfolio(@port_attrs, :json)
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
      let(:data) { { name: :update_name } }
      let(:id) { port.id }
      def action(args_hash)
        put :update, id: args_hash[:id], portfolio: args_hash[:data] , format:  args_hash[:format] 
      end   
    end

    context 'authorized user' do
      def update_portfolio(attrs, format)
        login_user
        put :update, id: port.id, portfolio: attrs , format: format         
      end
      context 'HTML or XML format' do
        [:html, :xml].each do |format|
          before :each do
            update_portfolio({ description: :boom }, format )
          end
          it_should_behave_like 'responds with 406 not acceptable'
        end
      end
      context 'JSON format' do
        context 'valid input' do
          before :each do
            update_portfolio( { description: :boom }, :json )
            @parsed = JSON.parse(response.body)
          end
          it_should_behave_like 'an action that responds with JSON'
          it_should_behave_like 'responds with success 200 status code'
          it 'returns the updated portfolio' do
            @parsed['portfolio']['id'].should == port.id
          end
        end
        context 'invalid input' do
          describe 'invalid portfolio id' do
            it 'returns status code 404 not found' do
              port.id = '1111'   # change portfolio id to one that does not exist
              update_portfolio( { name: 'test' }, :json )
              expect(response.status).to eq(404)
            end
          end
        end
      end
    end
  end

  ### DELETE ========================================================
  describe 'DELETE' do
    let!(:existing_port) { port }
    context 'unauthorized user' do
      it_should_behave_like 'a protected action' do 
        let(:id) { existing_port.id }
        def action(args_hash)
          delete :destroy, id: args_hash[:id] , format: args_hash[:format] 
        end   
      end
    end

    context 'with valid authorization token' do
      def delete_portfolio(id, format)
        login_user
        delete :destroy, id: id, format: format 
      end
      context 'with XML or HTML format' do
        [:xml, :html].each do |format| 
          it "should return 406 not acceptable for #{format}" do
            delete_portfolio(existing_port.id, format)
            expect(response.status).to eq(406)
          end
          it 'does not delete a portfolio' do
            expect do
              delete_portfolio(existing_port.id, format)
            end.to_not change(V1::Portfolio, :count)
          end
        end
      end
      context 'with JSON format' do
        context 'valid portfolio number specified' do
          it 'decreases number of portfolios by 1' do   
            expect do
              delete_portfolio(existing_port.id, :json)
            end.to change(V1::Portfolio, :count).by(-1)
          end
          it 'returns status code 200 success' do
            delete_portfolio(existing_port.id, :json)
            expect(response.status).to eq(200)
          end
        end
        context 'invalid portfolio number specified' do
          let(:invalid_id) { existing_port.id + 555 }
          it 'does not delete a portfolio' do
            expect do
              delete_portfolio(invalid_id, :json)
            end.to_not change(V1::Portfolio, :count)
          end
          it 'returns 404 not found status code' do
            delete_portfolio(invalid_id, :json)
            expect(response.status).to eq(404)
          end
        end
      end
    end
  end    
end
