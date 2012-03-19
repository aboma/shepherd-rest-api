class V1::PortfolioPresenter
  
  attr_reader :portfolio
  
  def initialize ( resource )
    @portfolio = resource
  end
  
  def as_json(include_root = false)
    port_hash = {
      :id => @portfolio.id,
      :name => @portfolio.name,
      :description => @portfolio.description,
      :url => "/portfolio/#{@portfolio.id}"
    }
    port_hash = { :portfolios => port_hash } if include_root
    port_hash
  end
end