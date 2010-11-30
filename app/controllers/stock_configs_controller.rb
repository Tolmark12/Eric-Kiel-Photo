class ConfigSettingsController < ApplicationController

  def index
    @stock_config = StockConfig.instance
  end

end