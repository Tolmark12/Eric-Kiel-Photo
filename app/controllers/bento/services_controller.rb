class Bento::ServicesController < Bento::BentoController

# POST /bento/services
# POST /bento/services.xml
def create
  @service = Service.new(params[:service])

  respond_to do |format|
    if @service.save
      @respond_type = :success
      @message = "#{@service.type} was successfully created."
      format.js   { render 'bento/shared/message'}
      format.html { redirect_to(bento_portfolios_url, :notice => @message) }
      format.xml  { render :xml => @service, :status => :created, :location => @service }
    else
      @respond_type = :error
    	@message = "#{@service.type} was not created. #{@service.errors.join(' ')}"
      format.js   { render 'bento/shared/message'}
      format.html { render :action => "new", :error => @message }
      format.xml  { render :xml => @service.errors, :status => :unprocessable_entity }
    end
  end
end

# PUT /bento/services/1
# PUT /bento/services/1.xml
def update
  @service = Service.find(params[:id])

  respond_to do |format|
    if @service.update_attributes(params[:service])
      @respond_type = :success
      @message = "#{@service.type} was successfully updated."
      format.js   { render 'bento/shared/message'}
      format.html { redirect_to(bento_portfolio_url(@service), :notice => @message) }
      format.xml  { head :ok }
    else
      @respond_type = :error
    	@message = "#{@service.type} was not updated. #{@service.errors.join(' ')}"
      format.js   { render 'bento/shared/message'}
      format.html { render :action => "edit", :error => @message }
      format.xml  { render :xml => @service.errors, :status => :unprocessable_entity }
    end
  end
end

# DELETE /bento/services/1
# DELETE /bento/services/1.xml
def destroy
  @service = Service.find(params[:id])
  @service.destroy

  respond_to do |format|
    format.html { redirect_to(bento_portfolios_url, :notice => "#{@service.type} was successfully deleted.") }
    format.xml  { head :ok }
  end
end
end