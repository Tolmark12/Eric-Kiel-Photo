class Bento::NavsController < Bento::BentoController
  # GET /bento/navs
  # GET /bento/navs.xml
  def index
    @navs = Nav.scoped

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @navs }
    end
  end

  # GET /bento/navs/1
  # GET /bento/navs/1.xml
  def show
    @nav = Nav.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nav }
      format.json { with_format(:html) do render('show', :layout => 'bento_json') end  }
    end
  end

  # GET /bento/navs/new
  # GET /bento/navs/new.xml
  def new
    @nav = Nav.new()

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nav }
      format.json { with_format(:html) do render('new', :layout => 'bento_json') end  }
    end
  end

  # GET /bento/navs/1/edit
  def edit
    @nav = Nav.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.json { with_format(:html) do render('edit', :layout => 'bento_json') end  }
    end
  end

  # POST /bento/navs
  # POST /bento/navs.xml
  def create
    @nav = (['Nav', 'SubNav'].include?(params[:nav][:type]))? params[:nav][:type].constantize.new(params[:nav]) : Nav.new(params[:nav])
    @nav.nav_item_ids = params[:nav_items] || []
    respond_to do |format|
      if @nav.save
        @respond_type = :success
        @message = 'Nav was successfully created.'
        format.js   { render 'bento/shared/message'}
        format.html { redirect_to(bento_navs_url, :notice => @message) }
        format.xml  { render :xml => @nav, :status => :created, :location => @nav }
      else
        @respond_type = :error
      	@message = "Nav was not created. #{@nav.errors.join(' ')}"
        format.js   { render 'bento/shared/message'}
        format.html { render :action => "new", :error => @message }
        format.xml  { render :xml => @nav.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bento/navs/1
  # PUT /bento/navs/1.xml
  def update
    @nav = Nav.find(params[:id])
    respond_to do |format|
      if @nav.update_attributes(params[:nav].merge({:nav_item_ids => params[:nav_items] || []}))
        @respond_type = :success
        @message = 'Nav was successfully updated.'
        format.js   { render 'bento/shared/message'}
        format.html { redirect_to(bento_nav_url(@nav), :notice => @message) }
        format.xml  { head :ok }
      else
        @respond_type = :error
      	@message = "Nav was not updated. #{@nav.errors.join(' ')}"
        format.js   { render 'bento/shared/message'}
        format.html { render :action => "edit", :error => @message }
        format.xml  { render :xml => @nav.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bento/navs/1
  # DELETE /bento/navs/1.xml
  def destroy
    @nav = Nav.find(params[:id])
    @nav.destroy

    respond_to do |format|
      format.html { redirect_to(bento_navs_url, :notice => 'Nav was successfully deleted.') }
      format.xml  { head :ok }
    end
  end

  def grid
    @navs = Nav.scoped
    render :partial => 'grid', :layout => false, :locals => {:body_only => true}
  end

end
