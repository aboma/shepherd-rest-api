class ApiVersion
  def initialize(version)
    @default = version
  end
  
  def matches?(req)
    @default || req.headers['Accept'].include?("application\luxin.v#{@version}")
  end
  
#  def matches?(request)
#   versioned_accept_header?(request) || version_one?(request)
#  end

#  private

#  def versioned_accept_header?(request)
#    accept = request.headers['Accept']
#    accept && accept[/application\/vnd\.luxin-v#{@version}\+json/]
#  end

#  def unversioned_accept_header?(request)
#    accept = request.headers['Accept']
#    accept.blank? || accept[/application\/vnd\.luxin/].nil?
#  end

#  def version_one?(request)
#    @version == 1 && unversioned_accept_header?(request)
#  end
end