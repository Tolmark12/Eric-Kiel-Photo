class Service
  include Rails.application.routes.url_helpers
  include Mongoid::Document 
  include Mongoid::Timestamps
  include Mongoid::NamedScope

  has_one :nav_item, inverse_of: :service,:autosave => true

  field :name, :type => String
  
  key :name

  def url
    @url ||= service_path({:id => self.id })
  end
  
  def as_json(options={})
    {
      :name => self.name
    }
  end
  
end
