class V1::SessionsController < Devise::SessionsController
  prepend_before_filter :require_no_authentication, :only => [:create ]
  
  def create
    respond_to do |format|
      format.json do
        current_user = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
        sign_in(resource_name, current_user)
        current_user.reset_authentication_token!
        render :status => 200, :json => { :session => { :success => true, :auth_token => current_user.authentication_token } }
      end
    end
#    user = login(params[:email], params[:password], params[:remember_me])
#    if user
#      redirect_back_or_to root_url, :notice => "Logged in!"
#    else
#      flash.now.alert = "Email or password was invalid"
#      render :new
#    end
  end
  
  def destroy
    respond_to do |format|
      format.json do
        current_user = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
        current_user.reset_authentication_token!
        render :status => :ok, :json => {}
      end
    end
    #logout
    #redirect_to login_url, :alert => "You have been logged out"
  end

end
