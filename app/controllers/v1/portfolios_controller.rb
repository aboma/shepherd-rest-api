class V1::PortfoliosController < V1::ApplicationController
  respond_to :json
  
  def index
    @portfolios = Portfolio.all
    @port_representation = @portfolios.map {|p| V1::PortfolioPresenter.new(p).as_json } 
    render :json => { :portfolios => @port_representation }, :content_type => 'application/json'
  end
  
  def create
    @portfolio = Portfolio.new(params[:portfolio].merge(:created_by_id => current_user.id, :updated_by_id => current_user.id))
    if @portfolio.save
      @p_pres = V1::PortfolioPresenter.new(@portfolio)
      render :json => { :portfolio => @p_pres.as_json }, :content_type => 'application/json'
    else 
      render :json => { :error => 'error creating portfolio' }, :status => :unprocessable_entity
    end
  end

  def show
    #TODO implement
    render :json => compose_json_error(:message => 'not implmented'), :status => :not_implemented
  end

  def update
    @portfolio = Portfolio.find(params[:id])
    if @portfolio.update_attributes(params[:portfolio].merge(:updated_by_id => current_user.id))
      @p_pres = V1::PortfolioPresenter.new(@portfolio)
      render :json => { :portfolio => @p_pres.as_json }, :content_type => 'application/json'
    else 
      @error_pres = V1::ErrorPresenter.new(@portfolio.errors)
      render :json => { :error => @error_pres.as_json }, :status => :unprocessable_entity
    end
  end

  def destroy
    if Portfolio.find(params[:id]).mark_deleted!(current_user.id)
      render :status => :OK
    else 
      render :status => :unprocessable_entity
    end
  end
  
end