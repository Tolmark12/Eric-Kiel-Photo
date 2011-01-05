class TagsController < ApplicationController
  # GET /bento/tags
  # GET /bento/tags.xml
  def index
    @tags = Tag.order_by(:text_id.asc)
    render :json => @tags.to_a.to_json
  end

  # GET /bento/tags/1
  # GET /bento/tags/1.xml
  def show
    @tag = Tag.find(params[:id])
    render :json => { :tags => @tag }
  end
end
