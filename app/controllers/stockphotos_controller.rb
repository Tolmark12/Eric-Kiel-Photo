class StockphotosController < ApplicationController
  # GET /bento/tags
  # GET /bento/tags.xml
  def by_ids
    @stockphotos = PortfolioItem.find(params[:ids].split(','))
    render :json => { :term => params[:ids], :items => @stockphotos }
  end

  # GET /bento/tags/1
  # GET /bento/tags/1.xml
  def by_tag
    @tags = Tag.where({:text_id => /#{params[:tag]}/i})
    render :json => { :term => params[:tag], :items => @tags.portfolio_items }
  end
end
