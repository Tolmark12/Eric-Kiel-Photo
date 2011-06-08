class StockConfigsController < ApplicationController

  def index
    @stock_config = StockConfig.instance
  end

end