class BentoFormPile < Blockpile::Base

  def build(element, *args)
    # use this instead of initialize
    @element      = (element.is_a?(Array)) ? element.last : element
    @form_options = [element,args]
    @options      = (args.map { |item| item }).extract_options!
    @options[:editable] ||= (@options[:editable].nil?) ? true : @options[:editable]
    @as           = @options.delete(:as) || ActiveModel::Naming.singular(@element)
    @form_builder = BentoBox::FormBuilder.new(@as, @element,@helper,{},nil)
    @options.merge!({:as => @as, :form_builder => @form_builder})
    @groups       = []
    @template     = 'bento/shared/components/bento_form'
  end

  def group(name,*args, &block)
    options  = args.extract_options!
    @groups  << name
    form_group_instance(name, options.merge!(@options), &block).to_html
  end

  def get_element
    @element
  end

  def get_groups
    @groups
  end

  def get_form_options
    @form_options
  end

  def get_options
    @options
  end

  def is_editable
    @options[:editable]
  end

  def submit(*args)
    options = args.extract_options!
    @form_builder.submit(*args, options.reverse_merge({:class => 'hidden'}))
  end

end
