class BentoUser < ActiveRecord::Base
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :rememberable, :trackable, :recoverable, :authentication_keys => [ :username ]
  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me
  
  alias_attribute :name, :username  

  has_and_belongs_to_many :roles
  
end
