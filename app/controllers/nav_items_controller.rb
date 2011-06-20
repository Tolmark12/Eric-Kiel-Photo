class NavItemsController < ApplicationController
  # GET /bento/nav_items
  # GET /bento/nav_items.xml
  def index
    @nav_items = NavItem.scoped.to_a

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @nav_items }
    end
  end

  # GET /bento/nav_items/1
  # GET /bento/nav_items/1.xml
  def show
    @nav_item = NavItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nav_item }
    end
  end
end
