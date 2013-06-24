module V1
  class UsersController < V1::ApplicationController
    include V1::Concerns::Auditable
    before_filter :allow_only_json_requests
    before_filter :find_user, :only => [:show, :create]

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
      user.attributes = add_audit_params(user, params[:user])
      user.save!
      return true
    rescue => e
      logger.error("error creating user #{e}")
      return false
    end
  end
end
