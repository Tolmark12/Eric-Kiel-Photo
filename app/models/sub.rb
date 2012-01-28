class Sub
  include Mongoid::Document 
  include Mongoid::Timestamps 
  

  has_many :nav_items, class_name: 'NavItem', inverse_of: :sub, :autosave => true
  
  field :name, :type => String
  field :type, :type => String, :default => 'Sub'
  key :name
  validates_uniqueness_of :name
    
  def as_json(options={})
    { :name => self.name,
      :kind => self.type}
  end
  
end
