class SubsController < ApplicationController
  # GET /bento/sub_navs
  # GET /bento/sub_navs.xml
  def index
    @subs = Sub.scoped

    render :json => @subs
  end

  # GET /bento/sub_navs/1
  # GET /bento/sub_navs/1.xml
  def show
    @sub = Sub.find(params[:id])

    render :json => @sub
  end
end
