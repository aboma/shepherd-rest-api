module VilioSharedExamples
  # This shared example requires an action parameter
  # that passes a function that calls the controller 
  shared_examples_for "a protected action" do 
    #ensure data variable exists
    data ||= nil
    
    [:json, :xml, :html].each do |format|            
      context "without authorization token" do   
        it "should return 401 unauthorized code for #{format}" do
          action(format, data)
          response.status.should == 401
        end     
      end
      
      context "with invalid authorization token" do
        it "should return 401 unauthorized code for #{format}" do
          request.env['X-AUTH-TOKEN'] = '111'
          action(format, data)
          subject.status.should == 401     
        end
      end
    end
  end
end