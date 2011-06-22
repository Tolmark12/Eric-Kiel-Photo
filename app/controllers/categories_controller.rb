class CategoriesController < ApplicationController
  # GET /bento/tags
  # GET /bento/tags.xml
  def index
    @categories = Category.scoped.to_a
    render :json => { :categories => @categories }
  end

  # GET /bento/tags/1
  # GET /bento/tags/1.xml
  def show
    @category = Category.find(params[:id])
    render :json => { :categories => @category }
  end
end
