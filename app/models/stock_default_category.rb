class StockDefaultCategory
  include Mongoid::Document 
  include Mongoid::Timestamps 
  
  field :text, :type => String
  field :src, :type => String
  field :search_term, :type => String
  
  def as_json(options = {})
    json              = {
      :text           => self.text,
      :src            => self.src,
      :search_term    => self.search_term
    }
    json
  end
end
