class Action 
  include Mongoid::Document
  
  field :action, :type => String
  
  references_and_referenced_in_many :roles, :inverse_of => :action
  
end