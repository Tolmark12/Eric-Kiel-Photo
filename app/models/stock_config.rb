require 'singleton'

class StockConfig < Service
  include Singleton
  
  field :name, :type => String, :default => 'stock_landing_page'
  field :faq_pricing, :type => String
  references_many :stock_default_categories, :stored_as => :array, :inverse_of => :stock_config
  references_many :form_definitions, :stored_as => :array, :inverse_of => :stock_config
  
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
      :stock_default_categories => self.stock_default_categories.to_a,
      :entity_id => self.id,
      :faq_pricing => self.faq_pricing,
      :form_definitions => self.form_definitions,
      :name => self.name
    }
  end
  
end