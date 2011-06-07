class Bento::RolesController < Bento::BentoController
  # GET /roles
  # GET /roles.xml
  def index
    @roles = Role.scoped

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @roles }
    end
  end

  # GET /roles/1
  # GET /roles/1.xml
  def show
    @role = Role.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @role }
      format.json { with_format(:html) do render('show', :layout => 'bento_json') end  }
    end
  end

  # GET /roles/new
  # GET /roles/new.xml
  def new
    @role = Role.new
    @actions = Action.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @role }
      format.json { with_format(:html) do render('new', :layout => 'bento_json') end  }
    end
  end

  # GET /roles/1/edit
  def edit
    @role = Role.find(params[:id])
    respond_to do |format|
      format.html # new.html.erb
      format.json { with_format(:html) do render('edit', :layout => 'bento_json') end  }
    end
  end

  # POST /roles
  # POST /roles.xml
  def create
    @role = Role.new(params[:role])

    respond_to do |format|
      if @role.save
        @respond_type = :success
        @message = 'Role was successfully created.'
        format.js   { render 'bento/shared/message'}
        format.html { redirect_to(bento_roles_url, :notice => @message) }
        format.xml  { render :xml => @role, :status => :created, :location => @role }
      else
        @respond_type = :error
      	@message = "Role was not created. #{@role.errors.join(' ')}"
        format.js   { render 'bento/shared/message'}
        format.html { render :action => "new" }
        format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /roles/1
  # PUT /roles/1.xml
  def update
    @role = Role.find(params[:id])

    respond_to do |format|
      if @role.update_attributes(params[:role])
        @respond_type = :success
        @message = 'Role was successfully updated.'
        format.js   { render 'bento/shared/message'}
        format.html { redirect_to(bento_role_url(@role), :notice => @message) }
        format.xml  { head :ok }
      else
        @respond_type = :error
      	@message = "Role was not updated. #{@role.errors.join(' ')}"
        format.js   { render 'bento/shared/message'}
        format.html { render :action => "edit" }
        format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.xml
  def destroy
    @role = Role.find(params[:id])
    @role.destroy

    respond_to do |format|
      format.html { redirect_to(bento_roles_url, :notice => 'Role was successfully deleted.') }
      format.xml  { head :ok }
    end
  end
  
  def grid
    @roles = Role.scoped
    with_format(:html) { render '_grid', :layout => 'bento_json', :locals => {:body_only => true} }
  end
  
end
