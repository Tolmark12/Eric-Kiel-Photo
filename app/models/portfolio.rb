class Portfolio < Service
  include Mongoid::Document
  include Mongoid::NamedScope
  references_and_referenced_in_many :portfolio_items
  referenced_in :nav_item
  

  #TODO Fix this to me more efficient
  # as of mongoid 2.0.0.rc.6 mongoid sorts all results by id
  def sorted_portfolio_items
    @sorted_portfolio_items ||= self.portfolio_items.order_by([[:order, :asc]]).to_a
  end

  def sorted_portfolio_items?
    self.portfolio_items?
  end


  def as_json(options={})
    { :name => self.name,
      :images => self.sorted_portfolio_items.as_json,
      :sort_on => "null",
      :is_active => {:label=>"Enabled",:value => 1}
    }
  end

end
