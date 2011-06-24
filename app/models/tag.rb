class Tag 
  include Mongoid::Document 

  field :text_id, :type => String
  field :name, :type => String
  field :rank, :type => Integer

  references_and_referenced_in_many :stockphotos
  key :text_id
  
  set_callback(:save, :after) do |document|
      document.clear_cache
  end
  set_callback(:destroy, :after) do |document|
      document.clear_cache
  end

  validates_uniqueness_of :name

  def as_json(options={})
    {
      :id   => self.id,
      :name => self.name,
      :rank => self.rank
    }
  end

  protected
  def clear_cache
    expire_page(:controller=>"tags",:action=>"show",:id=>self.id)
    expire_page(:controller=>"tags",:action=>"index")
  end
end
