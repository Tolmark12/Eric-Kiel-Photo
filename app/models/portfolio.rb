class Portfolio < Service

  references_many :portfolio_items, :stored_as => :array, :inverse_of => :portfolio
  referenced_in :nav_item

  def as_json(options={})
    { :name => self.name,
      :images => self.portfolio_items.as_json,
      :sort_on => "null",
      :is_active => {:label=>"Enabled",:value => 1}
    }
  end

end
