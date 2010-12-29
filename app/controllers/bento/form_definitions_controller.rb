class Bento::FormDefinitionsController < Bento::BentoController
  # GET /bento/form_definitions
  # GET /bento/form_definitions.xml
  def index
    @form_definitions = FormDefinition.scoped

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @form_definitions }
    end
  end

  # GET /bento/form_definitions/1
  # GET /bento/form_definitions/1.xml
  def show
    @form_definition = FormDefinition.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @form_definition }
      format.json { with_format(:html) do render('show', :layout => 'bento_json') end  }
    end
  end

  # GET /bento/form_definitions/new
  # GET /bento/form_definitions/new.xml
  def new
    @form_definition = FormDefinition.new()

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @form_definition }
      format.json { with_format(:html) do render('new', :layout => 'bento_json') end  }
    end
  end

  # GET /bento/form_definitions/1/edit
  def edit
    @form_definition = FormDefinition.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.json { with_format(:html) do render('edit', :layout => 'bento_json') end  }
    end
  end

  # POST /bento/form_definitions
  # POST /bento/form_definitions.xml
  def create
    @form_definition = FormDefinition.new(params[:form_definition].merge({:tag_ids => params[:tags] || []}))

    respond_to do |format|
      if @form_definition.save
        @respond_type = :success
        @message = 'Portfolio item was successfully created.'
        format.js   { render 'bento/shared/message'}
        format.html { redirect_to(bento_form_definitions_url, :notice => @message) }
        format.xml  { render :xml => @form_definition, :status => :created, :location => @form_definition }
      else
        @respond_type = :error
      	@message = "Portfolio item was not created. #{@form_definition.errors.join(' ')}"
        format.js   { render 'bento/shared/message'}
        format.html { render :action => "new", :error => @message }
        format.xml  { render :xml => @form_definition.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bento/form_definitions/1
  # PUT /bento/form_definitions/1.xml
  def update
    @form_definition = FormDefinition.find(params[:id])

    respond_to do |format|
      if @form_definition.update_attributes(params[:form_definition].merge({:tag_ids => params[:tags] || []}))
        @respond_type = :success
        @message = 'Portfolio item was successfully updated.'
        format.js   { render 'bento/shared/message'}
        format.html { redirect_to(bento_form_definition_url(@form_definition), :notice => @message) }
        format.xml  { head :ok }
      else
        @respond_type = :error
      	@message = "Portfolio item was not updated. #{@form_definition.errors.join(' ')}"
        format.js   { render 'bento/shared/message'}
        format.html { render :action => "edit", :error => @message }
        format.xml  { render :xml => @form_definition.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bento/form_definitions/1
  # DELETE /bento/form_definitions/1.xml
  def destroy
    @form_definition = FormDefinition.find(params[:id])
    @form_definition.destroy

    respond_to do |format|
      format.html { redirect_to(bento_form_definitions_url, :notice => 'Portfolio item was successfully deleted.') }
      format.xml  { head :ok }
    end
  end

  def grid
    @form_definitions = FormDefinition.scoped
    with_format(:html) { render '_grid', :layout => 'bento_json', :locals => {:body_only => true} }
  end

end
