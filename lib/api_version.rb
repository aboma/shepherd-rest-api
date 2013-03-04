class ApiVersion
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end
  
  def matches?(req)
    @default || req.headers['Accept'].include?("application\luxin.v#{@version}")
  end
end