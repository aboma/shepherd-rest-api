module VilioSharedExamples
  # This shared example requires an action parameter
  # that passes a function that calls the controller 
  shared_examples_for "a protected action" do 
    #add variables to hash
    args_hash = {}
    args_hash[:data] = data if defined? data
    args_hash[:id] = id if defined? id
    
    [:json, :xml, :html].each do |format|            
      context "without authorization token" do   
        it "should return 401 unauthorized code for #{format}" do
          args_hash[:format] = format
          action(args_hash)
          response.status.should == 401
        end     
      end
      
      context "with invalid authorization token" do
        it "should return 401 unauthorized code for #{format}" do
          args_hash[:format] = format
          request.env['X-AUTH-TOKEN'] = '111'
          action(args_hash)
          subject.status.should == 401     
        end
      end
    end
  end
  
  # Shared example that test a JSON index action on a controller
  # to see that it returns 406 for other formats and 200
  # for JSON format
  shared_examples_for "JSON controller index action" do
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
    
    before :each do
      get_index :json, @auth_token 
    end
    
    it_should_behave_like "an action that responds with JSON"
  end
  
  # Test whether response is success and content type returned is JSON
  shared_examples_for "an action that responds with JSON" do
    it "responds with success 200 status code" do
      response.status.should == 200       
    end       
    it "responds with JSON format" do
      response.header['Content-Type'].should include 'application/json'
    end
  end
end 