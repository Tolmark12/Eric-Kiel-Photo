class Contact < Sub
  
  
  def as_json(options={})
    { :name => self.name,
      :kind => 'contact'}
  end

end