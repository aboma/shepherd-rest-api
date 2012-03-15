class V1::UsersController < V1::ApplicationController
  respond_to :json
  
  def index
    @users = User.all
    @user_presenter = @users.map {|u| V1::UserPresenter.new(u).as_json } 
    respond_with @user_presenter
  end
  
  def show
    @user = User.find_by_id( params[:id] )
    render :status => 404 unless @user
    @user_presenter = V1::UserPresenter.new(@user)
    respond_with @user_presenter.as_json
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