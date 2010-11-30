class CreatePortfoliosPortfolioItems < ActiveRecord::Migration
  def self.up
    create_table :portfolios_portfolio_items, :id => false do |t|
      t.integer :portfolio_id
      t.integer :portfolio_item_id
    end
  end

  def self.down
    drop_table :portfolios_portfolio_items
  end
end