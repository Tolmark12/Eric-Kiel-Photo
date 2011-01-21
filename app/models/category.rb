class Category 
  include Mongoid::Document 

  field :text_id, :type => String
  field :name, :type => String
  field :rank, :type => Integer

  references_and_referenced_in_many :services
  key :text_id
  
  validates_uniqueness_of :name

  def as_json(options={})
    {
      :id   => self.text_id,
      :name => self.name,
      :rank => self.rank
    }
  end
end
