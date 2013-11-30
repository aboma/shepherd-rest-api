module V1
  class SettingsController < V1::ApplicationController
    respond_to :json, :except => [:create]

    def index
      respond_to do |format|
        format.json do
          render :json => {}, :status => 405
        end
      end
    end

    def show
      respond_to do |format|
        format.json do
          render :json => Settings, :root => :setting, :serializer => V1::SettingsSerializer
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

