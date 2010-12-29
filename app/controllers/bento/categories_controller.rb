class Bento::CategoriesController < Bento::BentoController
  # GET /bento/categories
  # GET /bento/categories.xml
  def index
    @categories = Category.scoped

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
    end
  end

  # GET /bento/categories/1
  # GET /bento/categories/1.xml
  def show
    @category = Category.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @category }
      format.json { with_format(:html) do render('show', :layout => 'bento_json') end  }
    end
  end

  # GET /bento/categories/new
  # GET /bento/categories/new.xml
  def new
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @category }
      format.json { with_format(:html) do render('new', :layout => 'bento_json') end  }
    end
  end

  # GET /bento/categories/1/edit
  def edit
    @category = Category.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.json { with_format(:html) do render('edit', :layout => 'bento_json') end  }
    end
  end

  # POST /bento/categories
  # POST /bento/categories.xml
  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        @respond_type = :success
        @message = 'Category was successfully created.'
        format.js   { render 'bento/shared/message'}
        format.html { redirect_to(bento_categories_url, :notice => @message) }
        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        @respond_type = :error
      	@message = "Category was not created. #{@category.errors.join(' ')}"
        format.js   { render 'bento/shared/message'}
        format.html { render :action => "new", :error => @message }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /bento/categories/1
  # PUT /bento/categories/1.xml
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        @respond_type = :success
        @message = 'Category was successfully updated.'
        format.js   { render 'bento/shared/message'}
        format.html { redirect_to(bento_category_url(@category), :notice => @message) }
        format.xml  { head :ok }
      else
        @respond_type = :error
      	@message = "Category was not updated. #{@category.errors.join(' ')}"
        format.js   { render 'bento/shared/message'}
        format.html { render :action => "edit", :error => @message }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bento/categories/1
  # DELETE /bento/categories/1.xml
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to(bento_categories_url, :notice => 'Category was successfully deleted.') }
      format.xml  { head :ok }
    end
  end

  def grid
    @categories = Category.scoped
    with_format(:html) { render '_grid', :layout => 'bento_json', :locals => {:body_only => true} }
  end

end
