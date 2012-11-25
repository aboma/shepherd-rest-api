class V1::SessionsController < Devise::SessionsController
  prepend_before_filter :get_auth_token
  prepend_before_filter :require_no_authentication, :only => [:create ]
  
  def create
    respond_to do |format|
      format.json do
        user = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
        render :status => 401, :json => { :message => "email or password incorrect" } unless user
        if user 
          sign_in(resource_name, user) 
          user.reset_authentication_token!
          render :status => 200, :json => { :session => { :success => true, :auth_token => current_user.authentication_token } }
        end
      end
    end
  end
  
  def destroy
    respond_to do |format|
      format.json do
        current_user = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
        current_user.reset_authentication_token!
        render :status => 200, :json => {}
      end
    end
  end
  
  # authentication failure
  def failure
    warden.custom_failure!
    render :status => 401, :json => { :session => { :success => false, :message => "Email of password invalid"}} 
  end
  
  def get_auth_token
    params[:auth_token] = request.headers["X-AUTH-TOKEN"]
  end
end
