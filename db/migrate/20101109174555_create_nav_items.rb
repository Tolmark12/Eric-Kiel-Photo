class CreateNavItems < ActiveRecord::Migration
  def self.up
    create_table :nav_items do |t|
      t.string :name
      t.references :nav
      t.string :url_id
      t.string :text
      t.boolean :is_logo
      t.references :sub, :polymorphic => true
      t.references :page_type
      t.string :nav_filter_tag
      t.boolean :is_default
      t.integer :sort
      t.references :serviceable, :polymorphic => true
      t.timestamps
    end
  end

  def self.down
    drop_table :nav_items
  end
end
