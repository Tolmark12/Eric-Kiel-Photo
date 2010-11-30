class FormField 
  include Mongoid::Document
  
  field :field_id, :type => String
  field :title, :type => String
  field :default_text, :type => String
  field :lines, :type => Integer
  field :url_var_name, :type => String
  field :regex_pattern, :type => String
  
  key :field_id
  
  def as_json(options={})
    {
      :field_id      => self.field_id,
      :title         => self.title,
      :default_text  => self.default_text,
      :lines         => self.lines,
      :url_var_name  => self.url_var_name,
      :regex_pattern => self.regex_pattern   
    }
  end
  
end
