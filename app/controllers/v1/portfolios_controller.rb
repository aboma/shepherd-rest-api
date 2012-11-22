class V1::PortfoliosController < V1::ApplicationController
  prepend_before_filter :get_auth_token
  before_filter :authenticate_user!
  
  respond_to :json
  
  # list all portfolios, including ones marked as deleted
  def index
    @portfolios = Portfolio.all
    respond_to do |format|
      format.json do
          render :json => @portfolios, :each_serializer => V1::PortfolioSerializer
       end
    end
  end
  
  # create portfolio and save created_by and updated_by user ids for audit purposes
  def create
    @portfolio = Portfolio.create(params[:portfolio].merge(:created_by_id => current_user.id, :updated_by_id => current_user.id))  
    respond_to do |format|
      format.json do
        if @portfolio.valid?
          render :json => @portfolio, :serializer => V1::PortfolioSerializer
        else 
          render :json => { :error => @portfolio.errors }, :status => :unprocessable_entity
        end
      end
    end
  end

  # show individual portfolio details
  def show
    @portfolio = Portfolio.find(params[:id])
    respond_to do |format|
      format.json do
        if @portfolio.valid?
          render :json => @portfolio, :serializer => V1::PortfolioSerializer
        else 
          render :json => { :error => @portfolio.errors }, :status => :unprocessable_entity
        end
      end
    end
  end

  # update portfolio and save updated by information for audit
  def update
    @portfolio = Portfolio.find(params[:id])
    @result = @portfolio.update_attributes(params[:portfolio].merge(:updated_by_id => current_user.id))
    respond_to do |format|
      format.json do
        if @result
          render :json => @portfolio, :serializer => V1::PortfolioSerializer
        else 
          @error_pres = V1::ErrorPresenter.new(@portfolio.errors)
          render :json => { :error => @error_pres.as_json }, :status => :unprocessable_entity
        end
      end
    end
  end

  def destroy  
    @portfolio = Portfolio.find(params[:id])
    @portfolio.destroy
    head :no_content
  end
  
end