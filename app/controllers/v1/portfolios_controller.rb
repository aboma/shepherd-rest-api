module V1
  class PortfoliosController < V1::ApplicationController
    include V1::Concerns::Auditable
    before_filter :find_portfolio, :only => [:show, :update, :destroy]
    respond_to :json

    # list all portfolios
    def index
      portfolios = Portfolio.all
      respond_to do |format|
        format.json do
          render json: portfolios, :each_serializer => V1::PortfolioSerializer
        end
      end
    end

    # create portfolio and save created_by and updated_by user ids for audit purposes
    def create
      @portfolio = V1::Portfolio.new
      respond_to do |format|
        format.json do
          if update_portfolio(@portfolio)
            response.headers['Location'] = portfolio_path(@portfolio)
            render json: @portfolio, serializer: V1::PortfolioSerializer
          else 
            status = conflict? ? :conflict : :unprocessable_entity
            render json: { errors: @portfolio.errors }, status: status
          end
        end
      end
    end

    # show individual portfolio details
    def show
      respond_to do |format|
        format.json do
          render json: @portfolio, serializer: V1::PortfolioSerializer if @portfolio
          render json: {}, status: 404 unless @portfolio
        end
      end
    end

    # update portfolio and save updated by information for audit
    def update
      respond_to do |format|
        format.json do
          if @portfolio && update_portfolio(@portfolio)
            @portfolio.reload
            render json: @portfolio, serializer: V1::PortfolioSerializer
          else 
            render json: { errors: { id: 'portfolio not found' } }, status: 404 unless @portfolio
            render json: { errors: @portfolio.errors }, status: :unprocessable_entity if @portfolio
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
            render json: nil, status: :ok if @portfolio.destroyed?
            render json: nil, status: 500 unless @portfolio.destroyed?
          else
            render json: { errors: @error }, status: 404
          end
        end
      end
    end

    private 

    def find_portfolio
      @portfolio = Portfolio.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @error = { id: 'portfolio not found' }
    end

    def update_portfolio(portfolio)
      portfolio.attributes = params[:portfolio]
      add_audit_params(portfolio)
      portfolio.save
    end

    def conflict?
       return @portfolio.errors[:name] && 
              @portfolio.errors[:name].include?('has already been taken')
    end

  end
end
