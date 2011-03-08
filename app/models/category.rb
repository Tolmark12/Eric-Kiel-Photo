class Category 
  include Mongoid::Document 

  field :text_id, :type => String
  field :name, :type => String
  field :rank, :type => Integer

  references_and_referenced_in_many :portfolio_items, :inverse_of => :categories
  # TODO: Remove this once mongoid fixes this upstream https://github.com/mongoid/mongoid/issues#issue/622
  after_save :update_portfolio_items
  key :text_id
  
  validates_uniqueness_of :name

  def as_json(options={})
    {
      :id   => self.text_id,
      :name => self.name,
      :rank => self.rank
    }
  end

private
  def update_portfolio_items
    for portfolio_item in self.portfolio_items
      portfolio_item.category_ids ||= []
      unless portfolio_item.categories.include?(self)
        portfolio_item.categories << self
        portfolio_item.save
      end
    end
  end
end
