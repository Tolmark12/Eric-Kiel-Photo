class StockConfigsController < ApplicationController

  def index
    @stock_config = Rails.cache.fetch("stock_configs_index", :expires_in => 5.minutes) do
      StockConfig.instance
    end
  end

end