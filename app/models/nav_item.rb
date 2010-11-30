class NavItem 
  include Mongoid::Document 

  belongs_to_related :nav
     
  field :name, :type => String
  field :url_id, :type => String
  field :text, :type => String
  field :is_logo, :type => Boolean
  referenced_in :sub
  field :page_type, :type => String
  field :nav_filter_tag, :type => String
  field :is_default, :type => Boolean
  field :sort, :type => Integer
  referenced_in :service
  referenced_in :subs
  references_many :navs, :stored_as => :array, :inverse_of => :nav_item
  key :name

  def as_json(options={})
    { 
      :name           => self.name,
      :url_id         => self.url_id,
      :text           => self.text,
      :data_service   => (self.service.nil?)? "" : self.service.url,
      :is_logo        => self.is_logo,
      :sub            => self.sub.as_json,
      :page_type      => self.page_type,
      :nav_filter_tag => self.nav_filter_tag,
      :is_default     => self.is_default,
      :sort           => self.sort.to_s
    }
  end
end
