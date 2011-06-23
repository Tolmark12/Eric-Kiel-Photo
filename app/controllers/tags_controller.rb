class TagsController < ApplicationController
  # GET /bento/tags
  # GET /bento/tags.xml
  def index
    @tags = Rails.cache.fetch("tags_index", :expires_in => 5.minutes) do
        Tag.order_by(:text_id.asc)
      end
    render :json => @tags.to_a.to_json
  end

  # GET /bento/tags/1
  # GET /bento/tags/1.xml
  def show
    @tag = Rails.cache.fetch("tags_#{params[:id]}", :expires_in => 5.minutes) do
        Tag.find(params[:id])
      end
    render :json => { :tags => @tag }
  end
end
