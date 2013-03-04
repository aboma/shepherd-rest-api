module V1
  class UsersController < V1::ApplicationController
    respond_to :json
    
    def index
      @users = User.all
      @user_presenter = @users.map {|u| V1::UserPresenter.new(u).as_json } 
      render :json => @user_presenter.as_json
    end
    
    def show
      @user = User.find_by_id( params[:id] )
      respond_to do |format|
        format.json do
          render :json => {}, :status => 404 unless @user
          @user_presenter = V1::UserPresenter.new(@user)
          render :json => @user_presenter.as_json
        end
      end
    end
    
    def create
      @user = User.new(params[:email].merge(:created_by_id => current_user.id, :updated_by_id => current_user.id))
      @user.save
      if @user.valid? 
        @user_presenter = V1::UserPresenter.new(@user)
        render :json => @user_presenter.as_json 
      else
        head no_content, :status => 422
      end
    end
  end
end