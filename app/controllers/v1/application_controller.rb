class V1::ApplicationController < ApplicationController
  skip_before_filter :verify_authenticity_token
  prepend_before_filter :get_auth_token
  before_filter :authenticate_user!, :except => :cors_preflight_check
  after_filter :cors_set_access_control_headers, :log_user


  # respond to options requests with blank text/plain as per spec
  def cors_preflight_check
    logger.info '>>> responding to CORS request'
    head :ok , :content_type => 'text/plain'
  end

  private

  # get authorization token from HTTP header if it is not in the URL parameters
  def get_auth_token
    params[:auth_token] = request.headers['X-AUTH-TOKEN'] || cookies[:auth_token]
    #params[:auth_token] ||= session[:auth_token]
    unless request.method == 'OPTIONS'
      logger.info '>>> AUTH_TOKEN MISSING' unless params[:auth_token]
      logger.info '>>> no API version specfied' unless request.headers['X-API-Version']
    end
  end 

  # For all responses in this controller, return the CORS access control headers. 
  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = request.headers['Origin']
    headers['Access-Control-Allow-Credentials'] = 'true'
    headers['Access-Control-Allow-Headers'] = 'X-AUTH-TOKEN, X-API-VERSION, X-Requested-With, Content-Type, Accept, Origin, *'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Max-Age'] = '1728000'
  end

  def log_user
    logger.info "*** Current User is #{current_user.email}" unless request.method == 'OPTIONS'
  end

end
