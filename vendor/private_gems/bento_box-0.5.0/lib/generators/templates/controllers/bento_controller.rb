class Bento::<%= controller_class_name %>Controller < Bento::BentoController
  # GET <%= route_url %>
  # GET <%= route_url %>.xml
  def index
    @<%= plural_table_name %> = <%= class_name %>.scoped

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @<%= plural_table_name %> }
    end
  end

  # GET <%= route_url %>/1
  # GET <%= route_url %>/1.xml
  def show
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @<%= singular_table_name %> }
      format.json { with_format(:html) do render('show', :layout => 'bento_json') end  }
    end
  end

  # GET <%= route_url %>/new
  # GET <%= route_url %>/new.xml
  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @<%= singular_table_name %> }
      format.json { with_format(:html) do render('new', :layout => 'bento_json') end  }
    end
  end

  # GET <%= route_url %>/1/edit
  def edit
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    respond_to do |format|
      format.html # edit.html.erb
      format.json { with_format(:html) do render('edit', :layout => 'bento_json') end  }
    end
  end

  # POST <%= route_url %>
  # POST <%= route_url %>.xml
  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "params[:#{singular_table_name}]") %>

    respond_to do |format|
      if @<%= orm_instance.save %>
        @respond_type = :success
        @message = '<%= human_name %> was successfully created.'
        format.js   { render(*grid_instance(<%= class_name %>).message) }
        format.html { redirect_to(<%= index_helper %>_url, :notice => @message) }
        format.xml  { render :xml => @<%= singular_table_name %>, :status => :created, :location => @<%= singular_table_name %> }
      else
        @respond_type = :error
      	@message = "<%= human_name %> was not created. #{@<%= singular_table_name %>.errors.join(' ')}"
        format.js   { render(*grid_instance(<%= class_name %>).message) }
        format.html { render :action => "new", :error => @message }
        format.xml  { render :xml => @<%= orm_instance.errors %>, :status => :unprocessable_entity }
      end
    end
  end

  # PUT <%= route_url %>/1
  # PUT <%= route_url %>/1.xml
  def update
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>

    respond_to do |format|
      if @<%= orm_instance.update_attributes("params[:#{singular_table_name}]") %>
        @respond_type = :success
        @message = '<%= human_name %> was successfully updated.'
        format.js   { render(*grid_instance(<%= class_name %>).message) }
        format.html { redirect_to(<%= singular_url_helper %>_url(@<%= singular_table_name %>), :notice => @message) }
        format.xml  { head :ok }
      else
        @respond_type = :error
      	@message = "<%= human_name %> was not updated. #{@<%= singular_table_name %>.errors.join(' ')}"
        format.js   { render(*grid_instance(<%= class_name %>).message) }
        format.html { render :action => "edit", :error => @message }
        format.xml  { render :xml => @<%= orm_instance.errors %>, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE <%= route_url %>/1
  # DELETE <%= route_url %>/1.xml
  def destroy
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    @<%= orm_instance.destroy %>

    respond_to do |format|
      format.html { redirect_to(<%= index_helper %>_url, :notice => '<%= human_name %> was successfully deleted.') }
      format.xml  { head :ok }
    end
  end

  def grid
    @<%= plural_table_name %> = <%= class_name %>.scoped
    with_format(:html) { render '_grid', :layout => 'bento_json', :locals => {:body_only => true} }
  end

end
