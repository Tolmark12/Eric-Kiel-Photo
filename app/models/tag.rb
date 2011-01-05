class Tag 
  include Mongoid::Document 

  field :text_id, :type => String
  field :name, :type => String
  field :rank, :type => Integer

  references_many :stockphotos, :stored_as => :array, :inverse_of => :tag
  key :text_id
  
  validates_uniqueness_of :name

  def as_json(options={})
    {
      :id   => self.id,
      :name => self.name,
      :rank => self.rank
    }
  end
end
