class CreateNavs < ActiveRecord::Migration
  def self.up
    create_table :navs do |t|
      t.string :name
      t.string :type
      t.timestamps
    end
  end

  def self.down
    drop_table :navs
  end
end
