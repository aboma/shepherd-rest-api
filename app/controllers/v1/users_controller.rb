class V1::UsersController < V1::ApplicationController
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:email])
    if @user.save
      redirect_to root_url, :notice => "Signed up!"
    else
      render :new
    end
  end

end