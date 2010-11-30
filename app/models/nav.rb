class Nav < Sub 
    
  references_many :nav_items, :stored_as => :array, :inverse_of => :nav
  
    
  def as_json(options={})
    { :name => self.name,
      :pages => self.nav_items.as_json}
  end

end
