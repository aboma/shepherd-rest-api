module LoginHelper
  def create_test_user
    #create user and get authentication token for user
    @user = FactoryGirl.build(:v1_user)
    @pw = @user.password
    @user.save!
    @user.reset_authentication_token!
    @auth_token = @user.authentication_token
  end
  
  def destroy_test_user
    @user.destroy
  end
end