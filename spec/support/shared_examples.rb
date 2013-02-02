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
  
  shared_examples_for "responds with JSON" do
    it "responds with success 200 status code" do
      response.status.should == 200       
    end       
    it "responds with JSON format" do
      response.header['Content-Type'].should include 'application/json'
    end
  end
end 