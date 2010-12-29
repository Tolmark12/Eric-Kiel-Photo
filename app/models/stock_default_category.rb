class StockDefaultCategory
  include Mongoid::Document 
  include Mongoid::Timestamps 
  
  field :name, :type => String
  field :text, :type => String
  field :src, :type => String
  field :tag, :type => String
  field :search_term, :type => String
  

  key :name
  def as_json(options = {})
    json              = {
      :text           => self.text,
      :src            => self.src,
      :search_term    => self.search_term
    }
    json
  end
end
