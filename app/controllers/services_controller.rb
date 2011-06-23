class ServicesController < ApplicationController
  # GET /bento/services
  # GET /bento/services.xml
  def index
    @services = Rails.cache.fetch("services_index", :expires_in => 5.minutes) do
        Service.scoped.to_a
      end

    render :json => @services
  end

  # GET /bento/services/1
  # GET /bento/services/1.xml
  def show
    @service = Rails.cache.fetch("services_#{params[:id]}", :expires_in => 5.minutes) do
        Service.find(params[:id])
      end

    render :json => @service
  end
end
