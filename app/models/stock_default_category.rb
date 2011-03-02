class StockDefaultCategory
  include Mongoid::Document 
  include Mongoid::Timestamps 
  
  field :name, :type => String
  field :text, :type => String
  field :src, :type => String
  field :tag, :type => String
  field :search_term, :type => String
  
  # TODO: I have no idea if this is correct or not
  references_and_referenced_in_many :categories

  key :name
  def as_json(options = {})
    json              = {
      :text           => self.text,
      :src            => self.src,
      :search_term    => self.search_term,
      :is_active => {:label=>"Enabled",:value => 1}
    }
    json
  end
end
