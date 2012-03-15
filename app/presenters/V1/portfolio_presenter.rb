class V1::PortfolioPresenter
  attr_reader :portfolio
  
  def initialize ( resource )
    @portfolio = resource
  end
  
  def as_json(include_root = false)
    #TODO
  end
end