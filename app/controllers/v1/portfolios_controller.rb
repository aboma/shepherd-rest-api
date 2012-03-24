class V1::PortfoliosController < V1::ApplicationController
  respond_to :json
  
  def index
    @portfolios = Portfolio.all
    @port_representation = @portfolios.map {|p| V1::PortfolioPresenter.new(p).as_json } 
    render :json => { :portfolios => @port_representation }, :content_type => 'application/json'
  end
  
  def create
    @portfolio = Portfolio.new(params[:portfolio])
    if @portfolio.save
      @p_pres = V1::PortfolioPresenter.new(@portfolio)
      render :json => { :portfolio => @p_pres.as_json }, :content_type => 'application/json'
    end
  end

  def show
    #TODO implement
  end

  def update
    @portfolio = Portfolio.find(params[:id])
    if @portfolio.update_attributes(params[:portfolio])
      @p_pres = V1::PortfolioPresenter.new(@portfolio)
      render :json => { :portfolio => @p_pres.as_json }, :content_type => 'application/json'
    else 
      render :json => { :error => "error updating portfolio" }
    end
  end

  def destroy
    Portfolio.find(params[:id]).destroy
  end
end