module V1
  class SettingsController < V1::ApplicationController
    before_filter :allow_only_json_requests, :except => [:create]

    def index
      respond_to do |format|
        format.json do
          render :json => Settings, :serializer => V1::SettingsSerializer
        end
      end
    end

    def show
      respond_to do |format|
        format.json do
          render :json => {}, :status => 405
        end
      end
    end

    def create
      respond_to do |format|
        format.json do
          render :json => {}, :status => 405
        end
      end
    end

    def update
      respond_to do |format|
        format.json do
          render :json => {}, :status => 405
        end
      end
    end

    def destroy
      respond_to do |format|
        format.json do
          render :json => {}, :status => 405
        end
      end
    end

  end
end

