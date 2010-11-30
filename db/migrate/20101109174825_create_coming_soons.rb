class CreateComingSoons < ActiveRecord::Migration
  def self.up
    create_table :coming_soons do |t|
      t.string :message

      t.timestamps
    end
  end

  def self.down
    drop_table :coming_soons
  end
end
