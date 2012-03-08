class V1::ApplicationController < ApplicationController
  protect_from_forgery
  before_filter :require_login
  
  respond_to :html
  
  def index
  end
  
  def not_authenticated
    redirect_to :action => 'new', :alert => "Please login.", :controller => 'sessions'
  end

end