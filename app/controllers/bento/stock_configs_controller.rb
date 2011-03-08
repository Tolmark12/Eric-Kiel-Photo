class Bento::StockConfigsController < Bento::BentoController
  
  def index
    @stock_config = StockConfig.instance
    @stock_config.save!
  end
  
  # PUT /bento/stock_configs/1
  # PUT /bento/stock_configs/1.xml
  def update
    @stock_config = StockConfig.find(params[:id])

    respond_to do |format|
      if @stock_config.update_attributes(params[:stock_config])
        @respond_type = :success
        @message = 'Stock config was successfully updated.'
        format.js   { render(*grid_instance(StockConfig).message) }
        format.html { redirect_to(bento_config_settings_url, :notice => @message) }
        format.xml  { head :ok }
      else
        @respond_type = :error
      	@message = "Stock config was not updated. #{@stock_config.errors.join(' ')}"
        format.js   { render(*grid_instance(StockConfig).message) }
        format.html { render :action => "edit", :error => @message }
        format.xml  { render :xml => @stock_config.errors, :status => :unprocessable_entity }
      end
    end
  end
end