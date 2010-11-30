class DeviseCreateBentoUsers < ActiveRecord::Migration
  def self.up
    create_table(:bento_users) do |t|
      t.string     :username
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable


      t.timestamps
    end
    
    add_index :bento_users, :username,                :unique => true
    add_index :bento_users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true

    admin = BentoUser.create(:username => 'admin', :password => 'password')
    admin.save

  end

  def self.down
    drop_table :bento_users
  end
end