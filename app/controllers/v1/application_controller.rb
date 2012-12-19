class V1::ApplicationController < ApplicationController
  skip_before_filter :verify_authenticity_token
  prepend_before_filter :get_auth_token
  before_filter :authenticate_user!
  
  respond_to :json, :html
  
  def index
    respond_to do |format|
      format.html do
        render :index
      end
    end
  end

  private
  
  # get authorization token from HTTP header if it is not in the URL parameters
  def get_auth_token
    params[:auth_token] = request.headers["X-AUTH-TOKEN"]
    params[:auth_token] ||= session[:auth_token]
    logger.info ">>> AUTH_TOKEN MISSING" unless request.headers["X-AUTH-TOKEN"]
    logger.info ">>> no API version specfied" unless request.headers["X-API-Version"]
  end 
  
end