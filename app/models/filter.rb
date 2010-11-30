class Filter 
  include Mongoid::Document 

  field :name, :type => String
  embedded_in :filterable, :inverse_of => :filter

  def as_json(options={})
    {
      :id   => self.text_id,
      :name => self.name,
      :rank => self.rank
    }
  end
end