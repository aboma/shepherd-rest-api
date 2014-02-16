module LoginHelper
  def login_user
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:v1_user)
    sign_in @user
  end
end
