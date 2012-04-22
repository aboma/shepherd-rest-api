class V1::ApplicationController < ApplicationController
  protect_from_forgery
  before_filter :require_login
  
  respond_to :html, :json
  
  def index
  end
  
  def not_authenticated
    redirect_to :action => 'new', :alert => "Please login.", :controller => 'sessions'
  end

  def compose_json_error(hash)
    error_json = {
      :status => 'error',
      :message => 'error occurred'
    }.merge(hash)
  end
end