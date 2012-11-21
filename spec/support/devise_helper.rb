module DeviseControllerHelpers
  def login_user
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @resource = FactoryGirl.create(:user)
    #user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the confirmable module
    user = sign_in(:user, @resource)
    debugger
  end
end