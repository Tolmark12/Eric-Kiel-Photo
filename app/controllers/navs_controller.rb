class NavsController < ApplicationController
  # GET /bento/navs
  # GET /bento/navs.xml
  def index
    @navs = Nav.scoped

    render :json => @navs
  end

  # GET /bento/navs/1
  # GET /bento/navs/1.xml
  def show
    @nav = Nav.find(params[:id])

    render :json => @navs
  end
end
