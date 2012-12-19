class LoginFailureApp < Devise::FailureApp

  def respond
    if api_token_failure?
      invalid_token
    elsif api_login_failure?
      invalid_credentials
    else
      flash[:notice] = i18n_message
      redirect_to redirect_url
    end
  end
      
  def invalid_token
    self.status = 401
    self.content_type = request.format.to_s
    self.response_body = "Access denied, invalid token."
  end
  
  def invalid_credentials
    self.status = 401
    self.content_type = request.format.to_s
    self.response_body = "Access denied, invalid credentials. To log in, please provide valid :email and :password parameters scoped to the :user parameter key."
  end

  def api_token_failure?
    api_login_failure? && request.params.has_key?("auth_token")
  end

  def api_login_failure?
    request.format == "application/json" && env['warden.options'][:action] == "unauthenticated"
  end

  def redirect_url
    login_path
  end
  
  def i18n_message
    "Incorrect username or password"
  end
end