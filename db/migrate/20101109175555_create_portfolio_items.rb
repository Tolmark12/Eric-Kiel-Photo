class CreatePortfolioItems < ActiveRecord::Migration
  def self.up
    create_table :portfolio_items do |t|
      t.string :name
      t.string :src
      t.string :low_res_src
      t.string :video_embed_code
      t.boolean :is_video_only

      t.timestamps
    end
  end

  def self.down
    drop_table :portfolio_items
  end
end
