module V1 
  class RelationshipsController < V1::ApplicationController
    before_filter :find_portfolio, :only => [:index]
    
    # Either return all relationships or return relationships
    # filtered by portfolio or asset
    def index
      if (@portfolio)
        @relations = @portfolio.relationships
      else
        @relations = Relationship.find(:all)
      end
      respond_to do |format|
        format.json do
          if (@error)
            render :error => @error, :serializer => V1::RelationshipSerializer
          else
            render :json => @relations, :each_serializer => V1::RelationshipSerializer
          end
        end      
      end
    end
    
    private 
    
    # Find portfolio requested by user, if one is requested,
    # to filter relationships by
    def find_portfolio
      return nil unless params[:portfolio_id]
      @portfolio = Portfolio.find_by_id(params[:portfolio_id])
    rescue ActiveRecord::RecordNotFound
      @error = "portfolio not found"
    end
  end
end