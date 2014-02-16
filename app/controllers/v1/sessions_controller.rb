module V1
  class SessionsController < Devise::SessionsController
    prepend_before_filter :require_no_authentication, :only => [:create ]
    after_filter :cors_set_access_control_headers, :except => [:create]

    respond_to :json

    def create
      respond_to do |format|
        format.json do
          user = warden.authenticate!(scope: resource_name)
          render status: 401, json: { message: 'email or password incorrect' } unless user
          if user 
            sign_in(resource_name, user) 
            render status: :created, json: { session: { success: true } }
          end
        end
      end
    end

    # Validate session is still authorized
    def show
      respond_to do |format|
        format.json do
          warden.authenticate!(scope: resource_name)
          render json: current_user, serializer: V1::SessionSerializer
        end      
      end
    end

    def destroy
      respond_to do |format|
        format.json do
          warden.authenticate!(scope: resource_name)
          render status: 200, json: {}
        end
      end
    end

    # authentication failure
    def failure
      warden.custom_failure!
      render status: 401, json: { session: { success: false, :message => 'Email or password invalid'}}
    end

    protected 

    # For all responses in this controller, return the CORS access control headers. 
    def cors_set_access_control_headers
      headers['Access-Control-Allow-Origin'] = request.headers['Origin']
      headers['Access-Control-Allow-Credentials'] = 'true' 
      headers['Access-Control-Allow-Headers'] = 'X-API-VERSION, X-Requested-With, Content-Type, Accept, *'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
      headers['Access-Control-Max-Age'] = '1728000'
    end

  end
end
