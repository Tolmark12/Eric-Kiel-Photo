class Bento::SubNavsController < Bento::BentoController
  # GET /bento/sub_navs
  # GET /bento/sub_navs.xml
  def index
    @sub_navs = SubNav.scoped

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sub_navs }
    end
  end

  # GET /bento/sub_navs/1
  # GET /bento/sub_navs/1.xml
  def show
    @sub_nav = SubNav.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sub_nav }
      format.json { with_format(:html) do render('show', :layout => 'bento_json') end  }
    end
  end

  # GET /bento/sub_navs/new
  # GET /bento/sub_navs/new.xml
  def new
    @sub_nav = SubNav.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sub_nav }
      format.json { with_format(:html) do render('new', :layout => 'bento_json') end  }
    end
  end

  # GET /bento/sub_navs/1/edit
  def edit
    @sub_nav = SubNav.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.json { with_format(:html) do render('edit', :layout => 'bento_json') end  }
    end
  end

  # POST /bento/sub_navs
  # POST /bento/sub_navs.xml
  def create
    @sub_nav = SubNav.new(params[:sub_nav])

    respond_to do |format|
      if @sub_nav.save
        @respond_type = :success
        @message = 'Sub nav was successfully created.'
        format.js   { render 'bento/shared/message'}
        format.html { redirect_to(bento_sub_navs_url, :notice => @message) }
        format.xml  { render :xml => @sub_nav, :status => :created, :location => @sub_nav }
      else
        @respond_type = :error
      	@message = "Sub nav was not created. #{@sub_nav.errors.join(' ')}"
        format.js   { render 'bento/shared/message'}
        format.html { render :action => "new", :error => @message }
        format.xml  { render :xml => @sub_nav.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bento/sub_navs/1
  # PUT /bento/sub_navs/1.xml
  def update
    @sub_nav = SubNav.find(params[:id])

    respond_to do |format|
      if @sub_nav.update_attributes(params[:sub_nav])
        @respond_type = :success
        @message = 'Sub nav was successfully updated.'
        format.js   { render 'bento/shared/message'}
        format.html { redirect_to(bento_sub_nav_url(@sub_nav), :notice => @message) }
        format.xml  { head :ok }
      else
        @respond_type = :error
      	@message = "Sub nav was not updated. #{@sub_nav.errors.join(' ')}"
        format.js   { render 'bento/shared/message'}
        format.html { render :action => "edit", :error => @message }
        format.xml  { render :xml => @sub_nav.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bento/sub_navs/1
  # DELETE /bento/sub_navs/1.xml
  def destroy
    @sub_nav = SubNav.find(params[:id])
    @sub_nav.destroy

    respond_to do |format|
      format.html { redirect_to(bento_sub_navs_url, :notice => 'Sub nav was successfully deleted.') }
      format.xml  { head :ok }
    end
  end

  def grid
    @sub_navs = SubNav.scoped
    render :partial => 'grid', :layout => false, :locals => {:body_only => true}
  end

end
