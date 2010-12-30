class Bento::PortfolioItemsController < Bento::BentoController
  # GET /bento/portfolio_items
  # GET /bento/portfolio_items.xml
  def index
    @portfolio_items = PortfolioItem.scoped

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @portfolio_items }
    end
  end

  # GET /bento/portfolio_items/1
  # GET /bento/portfolio_items/1.xml
  def show
    @portfolio_item = PortfolioItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @portfolio_item }
      format.json { with_format(:html) do render('show', :layout => 'bento_json') end  }
    end
  end

  # GET /bento/portfolio_items/new
  # GET /bento/portfolio_items/new.xml
  def new
    @portfolio_item = PortfolioItem.new()

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @portfolio_item }
      format.json { with_format(:html) do render('new', :layout => 'bento_json') end  }
    end
  end

  # GET /bento/portfolio_items/1/edit
  def edit
    @portfolio_item = PortfolioItem.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.json { with_format(:html) do render('edit', :layout => 'bento_json') end  }
    end
  end

  # POST /bento/portfolio_items
  # POST /bento/portfolio_items.xml
  def create
    @portfolio_item = PortfolioItem.new(params[:portfolio_item])

    respond_to do |format|
      if @portfolio_item.save
        @respond_type = :success
        @message = 'Portfolio item was successfully created.'
        format.js   { render 'bento/shared/message'}
        format.html { redirect_to(bento_portfolio_items_url, :notice => @message) }
        format.xml  { render :xml => @portfolio_item, :status => :created, :location => @portfolio_item }
      else
        @respond_type = :error
      	@message = "Portfolio item was not created. #{@portfolio_item.errors.join(' ')}"
        format.js   { render 'bento/shared/message'}
        format.html { render :action => "new", :error => @message }
        format.xml  { render :xml => @portfolio_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bento/portfolio_items/1
  # PUT /bento/portfolio_items/1.xml
  def update
    @portfolio_item = PortfolioItem.find(params[:id])

    respond_to do |format|
      if @portfolio_item.update_attributes(params[:portfolio_item])
        @respond_type = :success
        @message = 'Portfolio item was successfully updated.'
        format.js   { render 'bento/shared/message'}
        format.html { redirect_to(bento_portfolio_item_url(@portfolio_item), :notice => @message) }
        format.xml  { head :ok }
      else
        @respond_type = :error
      	@message = "Portfolio item was not updated. #{@portfolio_item.errors.join(' ')}"
        format.js   { render 'bento/shared/message'}
        format.html { render :action => "edit", :error => @message }
        format.xml  { render :xml => @portfolio_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bento/portfolio_items/1
  # DELETE /bento/portfolio_items/1.xml
  def destroy
    @portfolio_item = PortfolioItem.find(params[:id])
    @portfolio_item.destroy

    respond_to do |format|
      format.html { redirect_to(bento_portfolio_items_url, :notice => 'Portfolio item was successfully deleted.') }
      format.xml  { head :ok }
    end
  end

  def grid
    @portfolio_items = PortfolioItem.scoped
    with_format(:html) { render '_grid', :layout => 'bento_json', :locals => {:body_only => true} }
  end

end
