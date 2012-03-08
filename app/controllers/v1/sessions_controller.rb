class V1::SessionsController < ApplicationController
  
  def new
    
  end
  
  def create
    user = login(params[:email], params[:password], params[:remember_me])
    if user
      redirect_back_or_to v1_root_url, :notice => "Logged in!"
    else
      flash.now.alert = "Email or password was invalid"
      render :new
    end
  end
  
  def destroy
    logout
    redirect_to v1_login_url, :alert => "You have been logged out"
  end

end
