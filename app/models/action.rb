class Action 
  include Mongoid::Document
  
  field :action, :type => String
  
  references_many :roles, :stored_as => :array, :inverse_of => :action
  
end