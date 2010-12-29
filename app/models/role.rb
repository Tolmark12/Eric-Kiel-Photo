class Role
  include Mongoid::Document

  field :name, :type => String
  
  references_many :bento_users, :stored_as => :array, :inverse_of => :role
  references_many :actions, :stored_as => :array, :inverse_of => :role

end