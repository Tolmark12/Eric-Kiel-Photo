class Bento::ConfigSettingsController < Bento::BentoController
  
  def index
    @config_settings = ConfigSetting.instance
    @config_settings.save!
  end
  
  # PUT /bento/config_settings/1
  # PUT /bento/config_settings/1.xml
  def update
    @config_settings = ConfigSetting.find(params[:id])

    respond_to do |format|
      if @config_settings.update_attributes(params[:config_setting])
        @respond_type = :success
        @message = 'Config settings were successfully updated.'
        format.js   { render(*grid_instance(ConfigSetting).message) }
        format.html { redirect_to(bento_config_settings_url, :notice => @message) }
        format.xml  { head :ok }
      else
        @respond_type = :error
      	@message = "Config settings were not updated. #{@config_settings.errors.join(' ')}"
        format.js   { render(*grid_instance(ConfigSetting).message) }
        format.html { render :action => "edit", :error => @message }
        format.xml  { render :xml => @config_settings.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
end
