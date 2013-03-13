class ApiVersion
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end
  
  def matches?(req)
    @default || req.headers['Accept'].include?("application\vilio.v#{@version}")
  end
end