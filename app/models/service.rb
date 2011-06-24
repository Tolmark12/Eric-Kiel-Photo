class Service
  include Rails.application.routes.url_helpers
  include Mongoid::Document 
  include Mongoid::Timestamps
  include Mongoid::NamedScope

  references_one :nav_items, :autosave => true

  field :name, :type => String
  
  key :name

  set_callback(:save, :after) do |document|
      document.clear_cache
  end
  set_callback(:destroy, :after) do |document|
      document.clear_cache
  end
  
  def url
    @url ||= service_path({:id => self.id })
  end
  
  def as_json(options={})
    {
      :name => self.name
    }
  end
  
  protected
  def clear_cache
    expire_page(:controller=>"services",:action=>"show",:id=>self.id)
    expire_page(:controller=>"services",:action=>"index")
  end
end
