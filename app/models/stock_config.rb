require 'singleton'

class StockConfig < Service
  include Singleton
  
  field :name, :type => String, :default => 'Stock Photos'
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
  
end