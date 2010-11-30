class Stockphoto
  include Mongoid::Document 
  include Mongoid::Timestamps 
  
  field :name, :type => String
  field :small_image, :type => String
  field :mid_image, :type => String
  field :image, :type => String
  field :rank, :type => Integer

  references_many :tags, :stored_as => :array, :inverse_of => :stockphoto
  
  def as_json(options = {})
    json              = {
      :id             => self.id,
      :name           => self.name,
      :tags           => self.tags.map(&:text_id),
      :small_image    => self.small_image,
      :mid_image      => self.mid_image,
      :image          => self.image
    }
    json
  end
end
