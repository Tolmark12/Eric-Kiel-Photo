class Bento::FormFieldsController < Bento::BentoController
  # GET /bento/form_fields
  # GET /bento/form_fields.xml
  def index
    @form_fields = FormField.scoped

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @form_fields }
    end
  end

  # GET /bento/form_fields/1
  # GET /bento/form_fields/1.xml
  def show
    @form_field = FormField.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @form_field }
      format.json { with_format(:html) do render('show', :layout => 'bento_json') end  }
    end
  end

  # GET /bento/form_fields/new
  # GET /bento/form_fields/new.xml
  def new
    @form_field = FormField.new()

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @form_field }
      format.json { with_format(:html) do render('new', :layout => 'bento_json') end  }
    end
  end

  # GET /bento/form_fields/1/edit
  def edit
    @form_field = FormField.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.json { with_format(:html) do render('edit', :layout => 'bento_json') end  }
    end
  end

  # POST /bento/form_fields
  # POST /bento/form_fields.xml
  def create
    @form_field = FormField.new(params[:form_field])

    respond_to do |format|
      if @form_field.save
        @respond_type = :success
        @message = 'Portfolio item was successfully created.'
        format.js   { render(*grid_instance(FormField).message) }
        format.html { redirect_to(bento_form_fields_url, :notice => @message) }
        format.xml  { render :xml => @form_field, :status => :created, :location => @form_field }
      else
        @respond_type = :error
      	@message = "Portfolio item was not created. #{@form_field.errors.join(' ')}"
        format.js   { render(*grid_instance(FormField).message) }
        format.html { render :action => "new", :error => @message }
        format.xml  { render :xml => @form_field.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bento/form_fields/1
  # PUT /bento/form_fields/1.xml
  def update
    @form_field = FormField.find(params[:id])

    respond_to do |format|
      if @form_field.update_attributes(params[:form_field])
        @respond_type = :success
        @message = 'Portfolio item was successfully updated.'
        format.js   { render(*grid_instance(FormField).message) }
        format.html { redirect_to(bento_form_field_url(@form_field), :notice => @message) }
        format.xml  { head :ok }
      else
        @respond_type = :error
      	@message = "Portfolio item was not updated. #{@form_field.errors.join(' ')}"
        format.js   { render(*grid_instance(FormField).message) }
        format.html { render :action => "edit", :error => @message }
        format.xml  { render :xml => @form_field.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bento/form_fields/1
  # DELETE /bento/form_fields/1.xml
  def destroy
    @form_field = FormField.find(params[:id])
    @form_field.destroy

    respond_to do |format|
      format.html { redirect_to(bento_form_fields_url, :notice => 'Portfolio item was successfully deleted.') }
      format.xml  { head :ok }
    end
  end

  def grid
    @form_fields = FormField.scoped
    with_format(:html) { render '_grid', :layout => 'bento_json', :locals => {:body_only => true} }
  end

end
