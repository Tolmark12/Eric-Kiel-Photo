class ConfigSettingsController < ApplicationController
  caches_page :index

  def index
    @config_settings = ConfigSetting.instance
  end

end