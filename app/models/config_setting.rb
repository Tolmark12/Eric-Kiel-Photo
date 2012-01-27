require 'singleton'

class ConfigSetting
  include Singleton
  include Mongoid::Document 
  
  field :default_nav, :type => String
  field :background_image, :type => String
  field :filters, :type => String
    
  def initialize(*args)
    @settings ||= ConfigSetting.first()
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
