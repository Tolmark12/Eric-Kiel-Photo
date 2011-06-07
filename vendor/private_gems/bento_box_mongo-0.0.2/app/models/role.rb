class Role
  include Mongoid::Document

  field :name, :type => String
  
  references_and_referenced_in_many :bento_users, :inverse_of => :role
  references_and_referenced_in_many :actions, :inverse_of => :role

end