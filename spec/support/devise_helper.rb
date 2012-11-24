module DeviseControllerHelpers
  def get_auth_token
    before :all do
      #create user and get authentication token for user
      @user = FactoryGirl.create(:user)
      @user.reset_authentication_token!
      @auth_token = @user.authentication_token
    end
    
    after :all do
      @user.destroy
    end
  end
  
  def create_user
    before :all do
      @user = FactoryGirl.build(:user)
      @pw = @user.password
      @user.save!
    end
    
    after :all do
      @user.destroy
    end
  end
    
end