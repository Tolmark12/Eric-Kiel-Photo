class SubsController < ApplicationController
  # GET /bento/sub_navs
  # GET /bento/sub_navs.xml
  def index
    @subs = Rails.cache.fetch("subs_index", :expires_in => 5.minutes) do
      Sub.scoped
    end

    render :json => @subs
  end

  # GET /bento/sub_navs/1
  # GET /bento/sub_navs/1.xml
  def show
    
    @sub = Rails.cache.fetch("config_#{params[:id]}", :expires_in => 5.minutes) do
        Sub.find(params[:id])
      end

    render :json => @sub
  end
end
