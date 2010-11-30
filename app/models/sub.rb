class Sub
  include Mongoid::Document 
  include Mongoid::Timestamps 

  references_many :nav_items 
  
  field :name, :type => String
  field :type, :type => String, :default => 'Sub'
  key :name
  
end
