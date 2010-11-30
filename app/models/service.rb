class Service
  include Rails.application.routes.url_helpers
  include Mongoid::Document 
  include Mongoid::Timestamps 

  references_one :nav_items 

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
