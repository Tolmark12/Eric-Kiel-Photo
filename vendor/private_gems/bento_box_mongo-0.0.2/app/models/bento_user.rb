class BentoUser
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  
  field :username
  
  validates_presence_of :username
  validates_uniqueness_of :username, :case_sensitive => false
  attr_accessible :username, :email, :password, :password_confirmation
  alias_attribute :name, :username
  alias_attribute :column_names, :fields
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [ :username ]

end
