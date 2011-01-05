class FormDefinition
  include Mongoid::Document 
  include Mongoid::Timestamps 
  
  field :form_id, :type => String
  field :port_url, :type => String
  field :title, :type => String
  field :description, :type => String
  field :form_icon, :type => String
  field :target_email, :type => String
  field :email_subject, :type => String
  field :email_body, :type => String

  key :form_id
  
  references_many :form_fields, :stored_as => :array, :inverse_of => :form_definition

  def as_json(options = {})
    json              = {
      :form_id        => self.form_id,
      :port_url       => self.port_url,
      :title          => self.title,
      :description    => self.description,
      :form_icon      => self.form_icon,
      :target_email   => self.target_email,
      :email_subject  => self.email_subject,
      :email_body     => self.email_body,
      :fields         => self.form_fields.as_json,
      :is_active => {:label=>"Enabled",:value => 1}
    }
    json
  end
end
