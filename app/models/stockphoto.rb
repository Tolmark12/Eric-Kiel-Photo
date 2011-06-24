class Stockphoto
  include Mongoid::Document 
  include Mongoid::Timestamps 
  
  field :name, :type => String
  field :small_image, :type => String
  field :mid_image, :type => String
  field :image, :type => String
  field :rank, :type => Integer
  field :small_width, :type => Integer
  field :mid_width, :type => Integer
  field :large_width, :type => Integer

  references_and_referenced_in_many :tags
  
  def as_json(options = {})
    json              = {
      :id                => self.id,
      :name              => self.name,
      :tags              => self.tag_ids.map{|id| {:name => id, :id => id, :rank => '1'}},
      :small_image       => self.small_image,
      :mid_image         => self.mid_image,
      :image             => self.image,
      :small_image_width => self.small_width.to_s,
      :rank => 0
    }
    json
  end
end
