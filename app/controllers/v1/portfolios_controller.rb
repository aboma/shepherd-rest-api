module V1
  class PortfoliosController < V1::ApplicationController
    include V1::Concerns::Auditable
    before_filter :allow_only_json_requests
    before_filter :find_portfolio, :only => [:show, :update, :destroy]

    # list all portfolios
    def index
      portfolios = Portfolio.all
      respond_to do |format|
        format.json do
          render :json => portfolios, :each_serializer => V1::PortfolioSerializer
        end
      end
    end

    # create portfolio and save created_by and updated_by user ids for audit purposes
    def create
      respond_to do |format|
        format.json do
          portfolio = V1::Portfolio.new
          if update_portfolio(portfolio)
            response.headers['Location'] = portfolio_path(portfolio)
            render :json => portfolio, :serializer => V1::PortfolioSerializer
          else 
            render :json => { :errors => portfolio.errors }, :status => :unprocessable_entity
          end
        end
      end
    end

    # show individual portfolio details
    def show
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
      respond_to do |format|
        format.json do
          if @portfolio && update_portfolio(@portfolio)
            @portfolio.reload
            render :json => @portfolio, :serializer => V1::PortfolioSerializer
          else 
            render :json => { :errors => { :id => 'portfolio not found' } }, :status => 404 unless @portfolio
            render :json => { :errors => @portfolio.errors }, :status => :unprocessable_entity if @portfolio
          end
        end
      end
    end

    # delete portfolio if it exists
    def destroy  
      respond_to do |format|
        format.json do
          if @portfolio
            @portfolio.destroy
            render :json => :head, :status => :ok 
          else
            render :json => { :errors => { :id => 'no portfolio at this address' } }, :status => 404
          end
        end
      end
    end

    private 

    def find_portfolio
      @portfolio = Portfolio.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @error = "portfolio not found"
    end

    def update_portfolio(portfolio)
      portfolio.attributes = params[:portfolio]
      add_audit_params(portfolio)
      portfolio.save
    end
  end
end
