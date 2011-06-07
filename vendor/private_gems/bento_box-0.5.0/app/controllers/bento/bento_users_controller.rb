class Bento::BentoUsersController < Bento::BentoController
  # GET /bento/bento_users
  # GET /bento/bento_users.xml
  def index
    @bento_users = BentoUser.scoped
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bento_users }
    end
  end

  # GET /bento/bento_users/1
  # GET /bento/bento_users/1.xml
  def show
    @bento_user = BentoUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bento_user }
      format.json { with_format(:html) do render('show', :layout => 'bento_json') end  }
    end
  end

  # GET /bento/bento_users/new
  # GET /bento/bento_users/new.xml
  def new
    @bento_user = BentoUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bento_user }
      format.json { with_format(:html) do render('new', :layout => 'bento_json') end  }
    end
  end

  # POST /bento/bento_users
  # POST /bento/bento_users.xml
  def create
    @bento_user = BentoUser.new(params[:bento_user])

    respond_to do |format|
      if @bento_user.save
        @respond_type = :success
        @message = 'User was successfully created.'
        format.js   { render 'bento/shared/message'}
        format.html { redirect_to(bento_bento_users_url, :notice => @message) }
        format.xml  { render :xml => @bento_user, :status => :created, :location => @bento_user }
      else
        @respond_type = :error
      	@message = "User was not created. #{@bento_user.errors.join(' ')}"
        format.js   { render 'bento/shared/message'}
        format.html { render :action => "new", :error => @message }
        format.xml  { render :xml => @bento_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bento/bento_users/1
  # DELETE /bento/bento_users/1.xml
  def destroy
    @bento_user = BentoUser.find(params[:id])
    @bento_user.destroy

    respond_to do |format|
      format.html { redirect_to(bento_bento_users_url, :notice => 'User was successfully deleted.') }
      format.xml  { head :ok }
    end
  end
  
  def grid
    @bento_users = BentoUser.scoped
    with_format(:html) { render '_grid', :layout => 'bento_json', :locals => {:body_only => true} }
  end
end
