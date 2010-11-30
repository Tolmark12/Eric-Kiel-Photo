class TagsController < ApplicationController
  # GET /bento/tags
  # GET /bento/tags.xml
  def index
    @tags = Tag.scoped
    render :json => { :tags => @tags }
  end

  # GET /bento/tags/1
  # GET /bento/tags/1.xml
  def show
    @tag = Tag.find(params[:id])
    render :json => { :tags => @tag }
  end
end
