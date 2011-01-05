class PortfolioItem < Service
  
  field :src, :type => String
  field :low_res_src, :type => String
  field :video_embed_code, :type => String
  field :is_video_only, :type => Boolean
  field :item_type, :type => String, :default => 'Image'
  field :rank, :type => Integer
  
  belongs_to_related :service
  
  references_many :categories, :stored_as => :array, :inverse_of => :portfolio_item
  references_many :portfolios, :stored_as => :array, :inverse_of => :portfolio_item
  
  def as_json(options={})
    json = {
      :name => self.name,
      :tags => ["default_portfolio"],
      :photo_tags => self.categories.map(&:text_id),
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
end
