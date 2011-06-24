class ServicesController < ApplicationController
  caches_page :index
  caches_page :show
  # GET /bento/services
  # GET /bento/services.xml
  def index
    @services = Service.scoped.to_a
    render :json => @services
  end

  # GET /bento/services/1
  # GET /bento/services/1.xml
  def show
    @service = Service.find(params[:id])

    render :json => @service
  end
end
