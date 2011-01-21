require 'singleton'

class StockConfig < Service
  include Singleton
  
  field :name, :type => String, :default => 'stock_landing_page'
  field :faq_pricing, :type => String
  references_and_referenced_in_many :stock_default_categories
  references_and_referenced_in_many :form_definitions
  
  def initialize(*args)
    @settings ||= StockConfig.first()
    if !@settings.nil?
      @attributes = @settings.attributes
      @settings   = super(@attributes)
    else
      @settings = super(*args)
      self.save!
    end
    @settings
  end
  
  def as_json(options={})
    {
      :default_stock_categories => self.stock_default_categories.to_a,
      :entity_id => self.id,
      :faq_pricing => self.faq_pricing,
      :form_definitions => self.form_definitions.to_a,
      :name => self.name,
      :is_active => {:label=>"Enabled",:value => 1}
    }
  end
  
end