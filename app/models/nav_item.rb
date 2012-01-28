class NavItem 
  include Mongoid::Document 

  belongs_to_related :nav
     
  field :name, :type => String
  field :url_id, :type => String
  field :text, :type => String
  field :is_logo, :type => Boolean
  belongs_to :sub, class_name: 'Sub', inverse_of: :nav_item
  field :page_type, :type => String
  field :nav_filter_tag, :type => String
  field :is_default, :type => Boolean
  field :sort, :type => Integer
  belongs_to :service, class_name: 'Service', inverse_of: :nav_item
  references_and_referenced_in_many :navs, class_name: 'Nav', inverse_of: :nav_items
  key :name

  def as_json(options={})
    json = { 
      :entity_id      => self.id,
      :name           => self.name,
      :url_id         => self.url_id,
      :text           => self.text,
      :is_active      => { :label => "Enabled", :value => 1},
      :nav_filter_tag => self.nav_filter_tag,
      :sort           => self.sort.to_s
    }
    json[:sub] = self.sub.as_json unless self.sub.nil?
    json[:data_service] = self.service.url unless self.service.nil?
    json[:is_logo] = self.is_logo if self.is_logo
    json[:is_default] = self.is_default if self.is_default
    json[:page_type] = self.page_type unless self.page_type.nil?
    json
  end
end
