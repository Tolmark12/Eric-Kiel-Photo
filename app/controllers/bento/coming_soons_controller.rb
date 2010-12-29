class Bento::ComingSoonsController < Bento::BentoController
  # GET /bento/coming_soons
  # GET /bento/coming_soons.xml
  def index
    @coming_soons = ComingSoon.scoped

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @coming_soons }
    end
  end

  # GET /bento/coming_soons/1
  # GET /bento/coming_soons/1.xml
  def show
    @coming_soon = ComingSoon.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @coming_soon }
      format.json { with_format(:html) do render('show', :layout => 'bento_json') end  }
    end
  end

  # GET /bento/coming_soons/new
  # GET /bento/coming_soons/new.xml
  def new
    @coming_soon = ComingSoon.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @coming_soon }
      format.json { with_format(:html) do render('new', :layout => 'bento_json') end  }
    end
  end

  # GET /bento/coming_soons/1/edit
  def edit
    @coming_soon = ComingSoon.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.json { with_format(:html) do render('edit', :layout => 'bento_json') end  }
    end
  end

  # POST /bento/coming_soons
  # POST /bento/coming_soons.xml
  def create
    @coming_soon = ComingSoon.new(params[:coming_soon])

    respond_to do |format|
      if @coming_soon.save
        @respond_type = :success
        @message = 'Coming soon was successfully created.'
        format.js   { render 'bento/shared/message'}
        format.html { redirect_to(bento_coming_soons_url, :notice => @message) }
        format.xml  { render :xml => @coming_soon, :status => :created, :location => @coming_soon }
      else
        @respond_type = :error
      	@message = "Coming soon was not created. #{@coming_soon.errors.join(' ')}"
        format.js   { render 'bento/shared/message'}
        format.html { render :action => "new", :error => @message }
        format.xml  { render :xml => @coming_soon.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bento/coming_soons/1
  # PUT /bento/coming_soons/1.xml
  def update
    @coming_soon = ComingSoon.find(params[:id])

    respond_to do |format|
      if @coming_soon.update_attributes(params[:coming_soon])
        @respond_type = :success
        @message = 'Coming soon was successfully updated.'
        format.js   { render 'bento/shared/message'}
        format.html { redirect_to(bento_coming_soon_url(@coming_soon), :notice => @message) }
        format.xml  { head :ok }
      else
        @respond_type = :error
      	@message = "Coming soon was not updated. #{@coming_soon.errors.join(' ')}"
        format.js   { render 'bento/shared/message'}
        format.html { render :action => "edit", :error => @message }
        format.xml  { render :xml => @coming_soon.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bento/coming_soons/1
  # DELETE /bento/coming_soons/1.xml
  def destroy
    @coming_soon = ComingSoon.find(params[:id])
    @coming_soon.destroy

    respond_to do |format|
      format.html { redirect_to(bento_coming_soons_url, :notice => 'Coming soon was successfully deleted.') }
      format.xml  { head :ok }
    end
  end

  def grid
    @coming_soons = ComingSoon.scoped
    with_format(:html) { render '_grid', :layout => 'bento_json', :locals => {:body_only => true} }
  end

end
