class SelectorPile < Blockpile::Base

  include BentoBox::Component::Sortable
  include BentoBox::Component::Filterable
  include BentoBox::Component::Paginatable

  def build(object, attribute_relation, *args)
    # use this instead of initialize
    @options         = args.extract_options!
    @attribute_label = @options[:attribute_label]
    @is_label_image  = @options[:is_label_image]
    @destination     = @options[:destination]
    @sortable        = @options[:sortable]
    @filterable      = @options[:filterable]
    @paginatable     = @options[:paginatable]
    @orderable       = @options[:orderable]
    @type            = (@options[:type] || "default")

    @object       = object

    @attribute_relation  = attribute_relation
    @attribute_class     = @attribute_relation.klass
    @attribute_class_str = @attribute_class.to_s

    @id                 = "selector-container-#{@attribute_class}".downcase
    @attribute_relation = init_sortable(@attribute_relation) if sortable?
    @attribute_relation = init_filterable(@attribute_relation) if filterable?

    @attribute_count    = @attribute_relation.count
    @column_count       = @options[:column_count] || 9
    @row_count          = @options[:row_count] || (@attribute_count < @column_count*20) ? (@attribute_count.to_f / @column_count.to_f).ceil : 20
    @attribute_relation = init_paginatable(@attribute_relation, @attribute_count, @options[:page] || 1,@column_count * @row_count) if paginatable?

  
    @template       = "bento/shared/components/selector_#{@type}"
    @template_body  = File.join(@template,"body")
  end

  def ajax_success
    @ajax_success ||= render( :partial => File.join(@template, 'ajax_success.js'), :locals => {:pile => self, :p => self})
  end

  def ajax_url
    bento_selector_path(:type => @type, :object => "#{@object.class}".underscore, :id => @object.id, 
                  :attribute => "#{@attribute_class}".underscore, :label => @attribute_label, 
                  :destination => @destination, :body_only => 1, :is_label_image => @is_label_image)
  end

  def get_object
    @object
  end

  def get_row_count
    @row_count
  end

  def get_column_count
    @column_count
  end

  def get_default_action
    @default_action
  end

  def get_attribute_relation
    @attribute_relation
  end

  def get_attribute_class
    @attribute_class  ||= @attribute_relation.klass
  end

  def get_attribute_class_str
    @attribute_class_str  ||= "#{get_attribute_class}"
  end

  def get_attribute_str_underscore
    @attribute_str_underscore  ||= get_attribute_class_str.underscore
  end

  def get_object_str_underscore
    @object_class ||= get_object_class.underscore
  end
  
  def get_object_class_str
    @object_class ||= get_object.class.to_s
  end

  def get_object_str_underscore
    @object_class_underscore ||= get_object_class_str.underscore
  end

  def get_attribute_count
    @attribute_count
  end

  def get_attribute_label
    @attribute_label
  end

  def get_destination
    @destination
  end

  def get_options
    @options
  end
  
  def is_orderable?
    @orderable
  end

  def is_label_image?
    @is_label_image
  end

  def get_tooltip
    @tooltip ||= @options[:tooltip]
  end

  def get_id
    @id
  end

  def body
    @body ||= render(:partial => @template_body, :locals => {:pile => self, :p => self})
  end
end
