require 'spec_helper'

# Uses shared examples to test common controller functionality
# such as authorization. These are loacted in shared_examples.rb
describe V1::PortfoliosController, :type => :controller do
  
  # get a valid authorization to use on requests
  get_auth_token
  
  # global helper methods
  def create_portfolio 
    @port = FactoryGirl.create(:portfolio) 
  end
  
  ### GET INDEX ==================================================
  describe "GET index" do   
    #shared example
    it_should_behave_like "a protected action" do
      def action(format, data)
        get :index, :format => format
      end      
    end

    context "with valid authorization token" do
      def get_index(format, token)
        request.env['X-AUTH-TOKEN'] = token if token
        get :index, :format => format
      end
    
      [:xml, :html].each do |format| 
        it "should return 406 code for format #{format}" do
          get_index format, @auth_token
          response.status.should == 406  
        end 
      end    
      it "should return 200 success code for json format" do
        get_index :json, @auth_token
        response.status.should == 200        
      end   
      it "should return list of portfolios in json format" do
        create_portfolio
        get_index :json, @auth_token
        parsed = JSON.parse(response.body)
        #TODO parsed.should have_json_path("portfolios")
      end   
    end 
  end
  
  ### GET SHOW ==========================================================
  describe "GET show" do  
    #shared example
    it_should_behave_like "a protected action" do
      let(:data) { { :id => @port.id } }
      def action(format, data)
        get :show, data, :format => format
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
        it "responds with success 200 status code" do
          response.status.should == 200       
        end    
        it "responds with JSON format" do
          response.header['Content-Type'].should include 'application/json'
        end
        it "responds with the asked for portfolio" do
          @parsed['portfolio']['id'].should == @port.id
        end
        it "responds with the portfolio name" do
          @parsed['portfolio']['name'].should == @port.name
        end
      end
      context "invalid portfolio id" do
        pending
      end
    end 
  end
  
  ### POST CREATE ========================================================
  describe "POST create" do
    #shared example
    it_should_behave_like "a protected action" do
      let(:data) { FactoryGirl.attributes_for(:portfolio) }
      def action(format, data)
        post :create, :portfolio => data, :format => format 
      end   
    end
          
    context "with valid authorization token" do 
      def post_portfolio attrs, format
        request.env['X-AUTH-TOKEN'] = @auth_token
        post :create, :portfolio => attrs, :format => format 
      end  
      context "with XML or HTML format" do
        pending
      end    
      context "with JSON format" do    
        context "with invalid attributes" do
          before :each do
            post_portfolio({ :inv_attr => "invalid port" }, :json)
          end
          it "responds with 422 unprocessable entity" do
            response.status.should == 422
          end
        end
          
        context "with valid attributes" do
          it "increases number of portfolios by 1" do   
            expect{ 
              post_portfolio(FactoryGirl.attributes_for(:portfolio), :json)
            }.to change(Portfolio, :count).by(1)
          end    
          
          before :each do
             @port_attrs = FactoryGirl.attributes_for(:portfolio)
             post_portfolio(@port_attrs, :json)
          end         
          it "responds with success 200 status code" do
            response.status.should == 200       
          end       
          it "responds with JSON format" do
            response.header['Content-Type'].should include 'application/json'
          end
          it "responds with Location header" do
            response.header['Location'].should be_present
          end
        end
      end
    end
  end
  
### PUT UPDATE ========================================================
  describe "PUT update" do
    
    context "unauthorized user" do
      [:json, :xml, :html].each do |format| 
        it "returns 401 unauthorized code for #{format}" do
          create_portfolio
          request.env['X-AUTH-TOKEN'] = '1111'
          put :update, :id => @port.id, :portfolio => { :name => :update } , :format => format 
          response.status.should == 401     
        end
      end
    end
    context "authorized user" do
      def update_portfolio(attrs, format)
        request.env['X-AUTH-TOKEN'] = @auth_token
        put :update, :id => @port.id, :portfolio => attrs , :format => format         
      end
      context "HTML or XML format" do
        it "returns 406 not acceptable code" do
          create_portfolio
          [:html, :xml].each do |format|
            update_portfolio( { :description => :boom }, format )
            response.status.should == 406
          end
        end
      end
      context "JSON format" do
        context "valid input" do
          before :each do
            create_portfolio
            update_portfolio( { :description => :boom }, :json )
          end
          it "returns 200 success status code" do
            response.status.should == 200
          end
          it "responds with JSON format" do
            response.header['Content-Type'].should include 'application/json'
          end
          it "returns the updated portfolio" do
            pending
          end
        end
        context "invalid input" do
          describe "changing portfolio id number" do
            it "returns status code 422" do
              create_portfolio
              update_portfolio( { :id => @port.id + 1 }, :json )
              response.status.should == 422
            end
          end
          describe "invalid portfolio id" do
            it "returns status code 404 not found" do
              pending
            end
          end
        end
      end
    end
  end
  
### DELETE ========================================================
  describe "DELETE" do   
    context "unauthorized user" do
      [:json, :xml, :html].each do |format| 
        it "should return 401 unauthorized code for #{format}" do
          create_portfolio
          request.env['X-AUTH-TOKEN'] = '1111'
          delete :destroy, { :id => @port.id }, :format => format 
          response.status.should == 401     
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
          it "should return 406 not acceptable for #{format}" do
            create_portfolio
            delete_portfolio( @port.id, format)
            response.status.should == 406
          end
        end
      end
      context "with JSON format" do
        context "valid portfolio number specified" do
          it "decreases number of portfolios by 1" do   
            create_portfolio
            expect { 
              delete_portfolio( @port.id, :json)
            }.to change(Portfolio, :count).by(-1)
          end
          it "returns status code 200 success" do
            create_portfolio
            delete_portfolio( @port.id, :json)
            response.status.should == 200
          end
        end
        context "invalid portfolio number specified" do
          it "does not change the number of portfolios" do
            create_portfolio
            id = @port.id + 5
            expect {
              delete_portfolio( id, :json)
            }.to_not change(Portfolio, :count)
          end
          it "returns 404 not found status code" do
            create_portfolio
            id = @port.id + 5
            delete_portfolio( id, :json)
            response.status.should == 404
          end
        end
      end
    end
  end    
end