module V1
  class UsersController < V1::ApplicationController
    include V1::Concerns::Auditable
    respond_to :json
    before_filter :find_user, :only => [:show, :create, :update]

    def index
      users = User.all
      respond_to do |format|
        format.json do
          render :json => users, :each_serializer => V1::UserSerializer
        end
      end
    end

    def show
      respond_to do |format|
        format.json do
          render :json => {}, :status => 404 unless @user
          render :json => @user, :serializer => V1::UserSerializer if @user
        end
      end
    end

    def create
      respond_to do |format|
        format.json do
          if @user 
            path = user_path(@user)
            render :json => { :errors => { :email => "value already exists at #{path}" } }, :status => :conflict
          else
            user = V1::User.new
            if update_user(user)
              response.headers["Location"] = user_path(user)
              render :json => user, :serializer => V1::UserSerializer
            else
              render :json => { :errors => user.errors }, :status => :unprocessable_entity
            end
          end
        end
      end
    end

    def update
      respond_to do |format|
        format.json do
          unless @user 
            render :json => {}, :status => :not_found
            return
          end
          if update_user(@user)
            @user.reload
            render :json => @user, :serializer => V1::UserSerializer
          else 
            status = conflict? ? :conflict : :unprocessable_entity
            render :json => { :errors => @user.errors }, :status => status 
          end
        end
      end
    end

  private

    def find_user
      @user = V1::User.find_by_id(params[:id])
      unless @user 
        if (params[:user] && params[:user][:email])
          @user = V1::User.find_by_email(params[:user][:email])
        end
      end
    end

    def update_user(user)
      if params[:user] && params[:user][:password].blank? 
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
      user.assign_attributes(params[:user])
      add_audit_params(user)
      user.save
    end

    def conflict?
       return @user.errors[:email] && 
              @user.errors[:email].include?("has already been taken")
    end

  end
end
