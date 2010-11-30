class CreateTagTagables < ActiveRecord::Migration
  def self.up
    create_table :tag_tagables do |t|
      t.references :tag
      t.references :tagable, :polymorphic => true

      t.timestamps
    end
  end

  def self.down
    drop_table :tag_tagables
  end
end
