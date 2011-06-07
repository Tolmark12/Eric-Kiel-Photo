class Portfolio < Service
  include Mongoid::NamedScope
  references_and_referenced_in_many :portfolio_items
  referenced_in :nav_item
  
  alias_attribute :orig_portfolio_items, :portfolio_items

  #TODO Fix this to me more efficient
  # as of mongoid 2.0.0.rc.6 mongoid sorts all results by id
  def portfolio_items
    @portfolio_items ||=  begin
                            e_ids = self.portfolio_item_ids.map {|e_id| { :_id => e_id } };
                            (e_ids == []) ? [] : PortfolioItem.any_of(e_ids)
                          end
  end

  def as_json(options={})
    { :name => self.name,
      :images => self.portfolio_items.as_json,
      :sort_on => "null",
      :is_active => {:label=>"Enabled",:value => 1}
    }
  end

end
