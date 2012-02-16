class PortfolioItem < Service
  include Mongoid::Document 
  
  field :src, :type => String
  field :low_res_src, :type => String
  field :video_embed_code, :type => String
  field :is_video_only, :type => Boolean
  field :item_type, :type => String, :default => 'Image'
  field :rank, :type => Integer
  field :order, :type => Integer
  
  belongs_to_related :service
  
  references_and_referenced_in_many :categories, :inverse_of => :portfolio_items
  # TODO: Remove this once mongoid fixes this upstream https://github.com/mongoid/mongoid/issues#issue/622
  after_save :update_categories
  references_and_referenced_in_many :portfolios
  
  def as_json(options={})
    json = {
      :name => self.name,
      :tags => ["default_portfolio"],
      :photo_tags => self.category_ids,
      :src => self.src,
      :low_res_src => self.low_res_src,
      :is_active => {:label=>"Enabled",:value => 1}
    }
    if self.item_type == 'Video' then
      json[:video_emved_code] = self.video_embed_code unless self.video_embed_code.nil? || self.video_embed_code.blank?
      json[:is_video_only] = "#{self.is_video_only}" unless self.is_video_only.nil?
    end
    json
  end

private
  def update_categories
    for category in self.categories
      category.portfolio_item_ids ||= []
      unless category.portfolio_items.include?(self)
        category.portfolio_items << self
        category.save
      end
    end
  end
end
