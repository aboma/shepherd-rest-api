class V1::ApplicationController < ApplicationController
  skip_before_filter :verify_authenticity_token
  prepend_before_filter :get_auth_token
  before_filter :authenticate_user!
  
  respond_to :json

  # get authorization token from HTTP header if it is not in the URL parameters
  def get_auth_token
    if auth_token = params[:auth_token].blank? && request.headers["X-AUTH-TOKEN"]
      params[:auth_token] = auth_token
    end
  end
  
end