class FormGroupPile < Blockpile::Base

  def form_methods
    @@form_methods ||= [:fields_for, :text_field, :password_field, :hidden_field, :file_field, 
                       :text_area, :check_box, :radio_button, :search_field, :telephone_field, :phone_field, 
                       :url_field, :email_field, :number_field, :range_field, :image_uploader]
  end
  
  delegate :fields_for, :label, :text_field, :password_field, :hidden_field, :file_field, 
                     :text_area, :check_box, :radio_button, :search_field, :telephone_field, :phone_field, 
                     :url_field, :email_field, :number_field, :range_field, :selector, :image_uploader,  :to => :form_builder

  def build(name, *args)
    @name         = name
    @options      = args.extract_options!
    @as           = @options.delete(:as)
    @form_builder = @options.delete(:form_builder) 
    @template     = 'bento/shared/components/form_group'
    unless @options[:editable]
      form_methods.each do |form_method|
        self.class_eval %{ def #{form_method}(*args)
          method = args[0]
          div    = '<div>'
          div    << @form_builder.object.send(method).to_s
          div    << '&nbsp;</div>'
          raw div 
        end }
      end
    end
  end

  def get_name
    @name
  end

  def get_options
    @options
  end

  def form_builder
    @form_builder
  end
  
end
