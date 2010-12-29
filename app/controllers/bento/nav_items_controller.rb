class Bento::NavItemsController < Bento::BentoController
  # GET /bento/nav_items
  # GET /bento/nav_items.xml
  def index
    @nav_items = NavItem.scoped

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
      format.json { with_format(:html) do render('show', :layout => 'bento_json') end  }
    end
  end

  # GET /bento/nav_items/new
  # GET /bento/nav_items/new.xml
  def new
    @nav_item = NavItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nav_item }
      format.json { with_format(:html) do render('new', :layout => 'bento_json') end  }
    end
  end

  # GET /bento/nav_items/1/edit
  def edit
    @nav_item = NavItem.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.json { with_format(:html) do render('edit', :layout => 'bento_json') end  }
    end
  end

  # POST /bento/nav_items
  # POST /bento/nav_items.xml
  def create
    @nav_item = NavItem.new(params[:nav_item])

    respond_to do |format|
      if @nav_item.save
        @respond_type = :success
        @message = 'Nav item was successfully created.'
        format.js   { render 'bento/shared/message'}
        format.html { redirect_to(bento_nav_items_url, :notice => @message) }
        format.xml  { render :xml => @nav_item, :status => :created, :location => @nav_item }
      else
        @respond_type = :error
      	@message = "Nav item was not created. #{@nav_item.errors.join(' ')}"
        format.js   { render 'bento/shared/message'}
        format.html { render :action => "new", :error => @message }
        format.xml  { render :xml => @nav_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bento/nav_items/1
  # PUT /bento/nav_items/1.xml
  def update
    @nav_item = NavItem.find(params[:id])

    respond_to do |format|
      if @nav_item.update_attributes(params[:nav_item])
        @respond_type = :success
        @message = 'Nav item was successfully updated.'
        format.js   { render 'bento/shared/message'}
        format.html { redirect_to(bento_nav_item_url(@nav_item), :notice => @message) }
        format.xml  { head :ok }
      else
        @respond_type = :error
      	@message = "Nav item was not updated. #{@nav_item.errors.join(' ')}"
        format.js   { render 'bento/shared/message'}
        format.html { render :action => "edit", :error => @message }
        format.xml  { render :xml => @nav_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bento/nav_items/1
  # DELETE /bento/nav_items/1.xml
  def destroy
    @nav_item = NavItem.find(params[:id])
    @nav_item.destroy

    respond_to do |format|
      format.html { redirect_to(bento_nav_items_url, :notice => 'Nav item was successfully deleted.') }
      format.xml  { head :ok }
    end
  end

  def grid
    @nav_items = NavItem.scoped
    with_format(:html) { render '_grid', :layout => 'bento_json', :locals => {:body_only => true} }
  end

end
