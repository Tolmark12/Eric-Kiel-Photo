class CreateMotherTables < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name
      t.timestamps
    end
    create_table :actions do |t|
      t.string :path
      t.timestamps
    end
    create_table :actions_roles, :id => false do |t|
      t.integer :action_id
      t.integer :role_id
    end
    create_table :bento_users_roles, :id => false do |t|
      t.integer :bento_user_id
      t.integer :role_id
    end
  end

  def self.down
    drop_table :roles
    drop_table :actions
    drop_table :actions_roles
    drop_table :bento_users_roles
  end
end