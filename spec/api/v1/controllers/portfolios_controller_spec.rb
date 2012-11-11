require 'spec_helper'

describe 'api/v1/projects', :type => :api do
  before do
    @portfolio = FactoryGirl.build(:portfolio)
  end
  
  describe "unauthorized user" do
     let(:url) { "/portfolios" }

     it "should return 401 unauthorized code" do
       get "#{url}"
       last_response.status.should be "401"
     end     
  end
  
  describe "portfolios listed for user" do
     let(:url) { "/portfolios" }
    
    subject do
      get "#{url}"
      JSON.parse(last_response.body)
    end
    
    it "should return a list of portfolios" do
      should be [ :portfolios => { :id => 1 }]
    end
  end
  
  
end