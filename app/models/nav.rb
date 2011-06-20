class Nav < Sub 
    
  references_and_referenced_in_many :nav_items
  
    
  def as_json(options={})
    { :name => self.name,
      :pages => self.nav_items.to_a.as_json}
  end

end
