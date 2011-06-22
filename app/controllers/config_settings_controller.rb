class ConfigSettingsController < ApplicationController

  def index
    @config_settings = ConfigSetting.instance
  end

end