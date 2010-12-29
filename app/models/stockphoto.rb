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

  references_many :tags, :stored_as => :array, :inverse_of => :stockphoto
  
  def as_json(options = {})
    json              = {
      :id                => self.id,
      :name              => self.name,
      :tags              => self.tags.map(&:text_id),
      :small_image       => self.small_image,
      :mid_image         => self.mid_image,
      :image             => self.image,
      :small_image_width => self.small_width
    }
    json
  end
end
