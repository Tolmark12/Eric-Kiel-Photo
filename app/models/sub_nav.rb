class SubNav < Nav

  
  def as_json(options = {})
    { :name           => self.name,
      :pages          => self.nav_items.as_json,
      :kind           => 'subNav'
      }
  end
end
