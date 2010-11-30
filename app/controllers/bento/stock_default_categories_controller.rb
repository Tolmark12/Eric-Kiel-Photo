class Bento::StockDefaultCategoriesController < Bento::BentoController
  # GET /bento/stock_default_categories
  # GET /bento/stock_default_categories.xml
  def index
    @stock_default_categories = StockDefaultCategory.scoped

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stock_default_categories }
    end
  end

  # GET /bento/stock_default_categories/1
  # GET /bento/stock_default_categories/1.xml
  def show
    @stock_default_category = StockDefaultCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @stock_default_category }
      format.json { with_format(:html) do render('show', :layout => 'bento_json') end  }
    end
  end

  # GET /bento/stock_default_categories/new
  # GET /bento/stock_default_categories/new.xml
  def new
    @stock_default_category = StockDefaultCategory.new()
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @stock_default_category }
      format.json { with_format(:html) do render('new', :layout => 'bento_json') end  }
    end
  end

  # GET /bento/stock_default_categories/1/edit
  def edit
    @stock_default_category = StockDefaultCategory.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.json { with_format(:html) do render('edit', :layout => 'bento_json') end  }
    end
  end

  # POST /bento/stock_default_categories
  # POST /bento/stock_default_categories.xml
  def create
    @stock_default_category = StockDefaultCategory.new(params[:stock_default_category])

    respond_to do |format|
      if @stock_default_category.save
        @respond_type = :success
        @message = 'StockDefaultCategory was successfully created.'
        format.js   { render 'bento/shared/message'}
        format.html { redirect_to(bento_stock_default_categories_url, :notice => @message) }
        format.xml  { render :xml => @stock_default_category, :status => :created, :location => @stock_default_category }
      else
        @respond_type = :error
      	 @message = "StockDefaultCategory was not created. #{@stock_default_category.errors.join(' ')}"
        format.js   { render 'bento/shared/message'}
        format.html { render :action => "new", :error => @message }
        format.xml  { render :xml => @stock_default_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bento/stock_default_categories/1
  # PUT /bento/stock_default_categories/1.xml
  def update
    @stock_default_category = StockDefaultCategory.find(params[:id])

    respond_to do |format|
      if @stock_default_category.update_attributes(params[:stock_default_category])
        @respond_type = :success
        @message = 'StockDefaultCategory was successfully updated.'
        format.js   { render 'bento/shared/message'}
        format.html { redirect_to(bento_stock_default_category_url(@stock_default_category), :notice => @message) }
        format.xml  { head :ok }
      else
        @respond_type = :error
      	 @message = "StockDefaultCategory was not updated. #{@stock_default_category.errors.join(' ')}"
        format.js   { render 'bento/shared/message'}
        format.html { render :action => "edit", :error => @message }
        format.xml  { render :xml => @stock_default_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bento/stock_default_categories/1
  # DELETE /bento/stock_default_categories/1.xml
  def destroy
    @stock_default_category = StockDefaultCategory.find(params[:id])
    @stock_default_category.destroy

    respond_to do |format|
      format.html { redirect_to(bento_stock_default_categories_url, :notice => 'StockDefaultCategory was successfully deleted.') }
      format.xml  { head :ok }
    end
  end

  def grid
    @stock_default_categories = StockDefaultCategory.scoped
    render :partial => 'grid', :layout => false, :locals => {:body_only => true}
  end

end
