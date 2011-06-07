class Role < ActiveRecord::Base

  has_and_belongs_to_many :bento_users

  has_and_belongs_to_many :actions
end