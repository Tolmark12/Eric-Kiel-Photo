class ConfigSettingsController < ApplicationController

  def index
    @config_settings = Rails.cache.fetch("config_settings", :expires_in => 5.minutes) do
        ConfigSetting.instance
      end
  end

end