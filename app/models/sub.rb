class Sub
  include Mongoid::Document 
  include Mongoid::Timestamps 
  

  references_many :nav_items, :autosave => true
  
  field :name, :type => String
  field :type, :type => String, :default => 'Sub'
  key :name
  validates_uniqueness_of :name
  
  set_callback(:save, :after) do |document|
      document.clear_cache
  end
  set_callback(:destroy, :after) do |document|
      document.clear_cache
  end
  
  def as_json(options={})
    { :name => self.name,
      :kind => self.type}
  end
  
  protected
  def clear_cache
    expire_page(:controller=>"subs",:action=>"show",:id=>self.id)
    expire_page(:controller=>"subs",:action=>"index")
  end
end
