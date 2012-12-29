class V1::ApplicationController < ApplicationController
  skip_before_filter :verify_authenticity_token
  prepend_before_filter :get_auth_token
  before_filter :authenticate_user!, :except => :options
  after_filter :cors_set_access_control_headers
  
  respond_to :json
   
  # respond to options requests with blank text/plain as per spec
  def options 
    #cors_set_access_control_headers
    render :text => '', :content_type => 'text/plain'
  end

  private
  
  # get authorization token from HTTP header if it is not in the URL parameters
  def get_auth_token
    params[:auth_token] = request.headers["X-AUTH-TOKEN"]
    params[:auth_token] ||= session[:auth_token]
    unless request.method == :options
      logger.info ">>> AUTH_TOKEN MISSING" unless request.headers["X-AUTH-TOKEN"]
      logger.info ">>> no API version specfied" unless request.headers["X-API-Version"]
    end
  end 
      
  # For all responses in this controller, return the CORS access control headers. 
  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Headers'] = 'X-AUTH-TOKEN, X-API-VERSION, X-Requested-With, Content-Type, Accept, Origin'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Max-Age'] = "1728000"
  end
  
  # If this is a preflight OPTIONS request, then short-circuit the
  # request, return only the necessary headers and return an empty
  # text/plain. 
  #def cors_preflight_check
  #  if request.method == :options
  #    logger.info "CORS preflight check invoked"
  #    cors_set_access_control_headers
  #    render :text => '', :content_type => 'text/plain'
  #  end
  #end
  
end