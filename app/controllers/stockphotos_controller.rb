class StockphotosController < ApplicationController
  # GET /bento/tags
  # GET /bento/tags.xml
  def by_ids
    @stockphotos = Stockphoto.find(params[:ids].split(','))
    render :json =>  @stockphotos.to_a
  end

  # GET /bento/tags/1
  # GET /bento/tags/1.xml
  def by_tag
    @tags = Tag.where({:text_id => params[:tag]})
    render :json => @tags.to_a.map(&:stockphotos).flatten.uniq 
  end
end
