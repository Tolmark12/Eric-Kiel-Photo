class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :text_id
      t.string :name
      t.integer :rank

      t.timestamps
    end
  end

  def self.down
    drop_table :tags
  end
end
