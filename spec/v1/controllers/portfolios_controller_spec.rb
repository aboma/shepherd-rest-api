require 'spec_helper'

# Uses shared examples to test common controller functionality
# such as authorization. These are located in shared_examples.rb
describe V1::PortfoliosController, :type => :controller do
  include LoginHelper
  
  # get a valid authorization to use on requests
  before :all do
    create_test_user
  end
  
  after :all do
    destroy_test_user
  end
  
  # global helper methods
  def create_portfolio 
    @port = FactoryGirl.create(:v1_portfolio) 
  end
  
  ### GET INDEX ==================================================
  describe "get INDEX" do   
    it_should_behave_like "a protected action" do
      def action(args_hash)
        get :index, :format => args_hash[:format]
      end
    end

    context "with valid authorization token" do
      it_should_behave_like "JSON controller index action"
#      it "should return list of portfolios in json format" do
#       create_portfolio
#        get_index :json, @auth_token
#        parsed = JSON.parse(response.body)
#        #TODO parsed.should have_json_path("portfolios")
#      end   
    end 
  end
  
  ### GET SHOW ==========================================================
  describe "get SHOW" do  
    context "unauthorized user" do
      before :each do
        create_portfolio
      end
      #shared example
      it_should_behave_like "a protected action" do
        let(:data) { { :id => @port.id } }
        def action(args_hash)
          get :show, args_hash[:data], :format => args_hash[:format]
        end      
      end 
    end
    
    context "with valid authorization token" do
      context "valid portfolio id" do
        before :each do
          create_portfolio
          request.env['X-AUTH-TOKEN'] = @auth_token
          get :show, :id => @port.id, :format => :json
          @parsed = JSON.parse(response.body)
        end
        it_should_behave_like "an action that responds with JSON"
        it "responds with success 200 status code" do
          response.status.should == 200       
        end
        it "responds with the asked for portfolio" do
          @parsed['portfolio']['id'].should == @port.id
        end
        it "responds with the portfolio name" do
          @parsed['portfolio']['name'].should == @port.name
        end
      end
      context "invalid portfolio id" do
        before :each do
          create_portfolio
          @port.id += 5
          request.env['X-AUTH-TOKEN'] = @auth_token
          get :show, :id => @port.id, :format => :json
        end
        it "responds with 404 not found" do
          response.status.should == 404
        end
      end
    end 
  end
  
  ### POST CREATE ========================================================
  describe "post CREATE" do
    it_should_behave_like "a protected action" do
      let(:data) { FactoryGirl.attributes_for(:v1_portfolio) }
      def action(args_hash)
        post :create, :portfolio => args_hash[:data], :format => args_hash[:format] 
      end   
    end
           
    context "with valid authorization token" do 
      def post_portfolio attrs, format
        request.env['X-AUTH-TOKEN'] = @auth_token
        post :create, :portfolio => attrs, :format => format 
      end  
      context "with XML or HTML format" do
        [:xml, :html].each do |format|
          before :each do
            post_portfolio(FactoryGirl.attributes_for(:v1_portfolio), format)          
          end
          it "should return 406 code for format #{format}" do
            response.status.should == 406  
          end
        end          
      end    
      context "with JSON format" do    
        context "without required attributes" do
          before :each do
            post_portfolio({ :inv_attr => "invalid attribute" }, :json)
          end
          it "responds with 422 unprocessable entity" do
            response.status.should == 422
          end
        end
        context "with invalid attributes" do
          pending
        end
          
        context "with valid attributes" do
          it "increases number of portfolios by 1" do   
            expect{ 
              post_portfolio(FactoryGirl.attributes_for(:v1_portfolio), :json)
            }.to change(V1::Portfolio, :count).by(1)
          end    
          
          before :each do
             @port_attrs = FactoryGirl.attributes_for(:v1_portfolio)
             post_portfolio(@port_attrs, :json)
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
  
  ### PUT UPDATE ========================================================
  describe "put UPDATE" do
    it_should_behave_like "a protected action" do
      port = FactoryGirl.create(:v1_portfolio) 
      let(:data) { { :name => :update_name } }
      let(:id) { port.id }
      def action(args_hash)
        put :update, :id => args_hash[:id], :portfolio => args_hash[:data] , :format => args_hash[:format] 
      end   
    end

    context "authorized user" do
      def update_portfolio(attrs, format)
        request.env['X-AUTH-TOKEN'] = @auth_token
        put :update, :id => @port.id, :portfolio => attrs , :format => format         
      end
      context "HTML or XML format" do
        [:html, :xml].each do |format|
          before :each do
            create_portfolio
            update_portfolio( { :description => :boom }, format )
          end
          it "returns 406 not acceptable code" do
            response.status.should == 406
          end
        end
      end
      context "JSON format" do
        context "valid input" do
          before :each do
            create_portfolio
            update_portfolio( { :description => :boom }, :json )
            @parsed = JSON.parse(response.body)
          end
          it_should_behave_like "an action that responds with JSON"
          it "returns 200 success status code" do
            response.status.should == 200
          end
          it "returns the updated portfolio" do
            @parsed['portfolio']['id'].should == @port.id
          end
        end
        context "invalid input" do
          before :each do 
            create_portfolio
          end
          describe "changing portfolio id number" do
            it "returns status code 422" do
              update_portfolio( { :id => @port.id + 111 }, :json )
              response.status.should == 422
            end
          end
          describe "invalid portfolio id" do
            it "returns status code 404 not found" do
              @port.id = '1111'   # change portfolio id to one that does not exist
              update_portfolio( { :name => 'test' }, :json )
              response.status.should == 404
            end
          end
        end
      end
    end
  end
  
  ### DELETE ========================================================
  describe "DELETE" do   
    context "unauthorized user" do
      it_should_behave_like "a protected action" do
        port = FactoryGirl.create(:v1_portfolio) 
        let(:id) { port.id }
        def action(args_hash)
          delete :destroy, :id => args_hash[:id] , :format => args_hash[:format] 
        end   
      end
    end
    
    context "authorized user" do
      def delete_portfolio(id, format)
        request.env['X-AUTH-TOKEN'] = @auth_token
        delete :destroy, :id => id, :format => format 
      end
      context "with XML or HTML format" do
        [:xml, :html].each do |format| 
          before :each do
            create_portfolio          
          end
          it "should return 406 not acceptable for #{format}" do
            delete_portfolio(@port.id, format)
            response.status.should == 406
          end
          it "does not delete a portfolio" do
            expect {
              delete_portfolio(@port.id, format)
            }.to_not change(V1::Portfolio, :count)
          end
        end
      end
      context "with JSON format" do
        context "valid portfolio number specified" do
          before :each do
            create_portfolio
          end
          it "decreases number of portfolios by 1" do   
            expect { 
              delete_portfolio( @port.id, :json)
            }.to change(V1::Portfolio, :count).by(-1)
          end
          it "returns status code 200 success" do
            delete_portfolio( @port.id, :json)
            response.status.should == 200
          end
        end
        context "invalid portfolio number specified" do
          before :each do
            create_portfolio
            @id = @port.id + 5            
          end
          it "does not delete a portfolio" do
            expect {
              delete_portfolio( @id, :json)
            }.to_not change(V1::Portfolio, :count)
          end
          it "returns 404 not found status code" do
            delete_portfolio( @id, :json)
            response.status.should == 404
          end
        end
      end
    end
  end    
end