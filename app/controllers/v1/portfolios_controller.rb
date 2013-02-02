class V1::PortfoliosController < V1::ApplicationController
  
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
          response.headers['Location'] = portfolio_path(@portfolio)
          render :json => @portfolio, :serializer => V1::PortfolioSerializer
        else 
          render :json => { :error => @portfolio.errors }, :status => :unprocessable_entity
        end
      end
    end
  end

  # show individual portfolio details
  def show
    @portfolio = Portfolio.find_by_id(params[:id])
    respond_to do |format|
      format.json do
        if @portfolio
          render :json => @portfolio, :serializer => V1::PortfolioSerializer
        else 
          render :json => {}, :status => 404
        end
      end
    end
  end

  # update portfolio and save updated by information for audit
  def update
    @portfolio = Portfolio.find_by_id(params[:id], :lock => true)
    if (params[:portfolio][:id] && params[:portfolio][:id] != params[:id])
      error = { :message => 'can not change portfolio id', :status => 422 }
    elsif !@portfolio
      error = { :message => 'portfolio not found', :status => 404 }
    else
      @updated_port = @portfolio.update_attributes(params[:portfolio].merge(:updated_by_id => current_user.id))
      @portfolio = Portfolio.find_by_id(params[:id])
    end
    respond_to do |format|
      format.json do
        if error 
          render :json => { :error => error[:message] }, :status => error[:status]
        elsif @updated_port
          render :json => @portfolio, :serializer => V1::PortfolioSerializer
        else 
          render :json => { :error => @updated_port.errors }, :status => :unprocessable_entity
        end
      end
    end
  end

  # delete portfolio if it exists
  def destroy  
    respond_to do |format|
      format.json do
        begin
          @portfolio = Portfolio.find(params[:id])
          @portfolio.destroy
          render :json => {}
        rescue ActiveRecord::RecordNotFound => e
          render :json => { :message => 'no portfolio at this address' }, :status => 404
        end
      end
    end
  end
  
  private 
  
  def find
    @portfolio = Portfolio.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    @error = "portfolio not found"
  end
end