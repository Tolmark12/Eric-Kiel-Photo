class GridPile < Blockpile::Base

  include BentoBox::Component::Sortable
  include BentoBox::Component::Filterable
  include BentoBox::Component::Paginatable
  
  
  def build(relation, *args)
    # use this instead of initialize
    @relation      = relation
    @element_class = relation.respond_to?(:klass) ? relation.klass : (relation.is_a?(Class) ? relation : relation.class)
    @id            = "grid-container-#{@element_class.to_s.underscore}"
    @options       = args.extract_options!
    @columns       = {}

    args.each { |attr|
      @columns[attr] = {:title => attr.to_s.titleize,:sortable => @element_class.column_names.include?(attr.to_s)}
    }

    @sortable           = @options[:sortable]
    @filterable         = @options[:filterable]
    @paginatable        = @options[:paginatable]
    @relation           = init_sortable(@relation) if sortable?
    @relation           = init_filterable(@relation) if filterable?  
    @relation           = init_paginatable(@relation, @relation.count,@options[:page] || 1,@options[:page_size] || 20) if paginatable?
    @template           = 'bento/shared/components/grid'  
    @template_body      = File.join(@template,"body")
    @javascript_actions = ""
  end
  
  def add_column(name,options={})
    options[:title]    ||= name.to_s.titleize
    options[:sortable] ||= @element_class.column_names.include?(name.to_s)
    options[:column]   ||= @element_class.columns_hash[name.to_s]
    @columns[name]      = options
  end
  
  def add_javascript_action(action)
    @javascript_actions << action
  end
  
  def grid_javascript
    grid_script = javascript_tag do 
      %{$(document).ready(function(){
        $('table.grid tbody tr').hover(function() \{$(this).addClass('highlight')\},function() \{$(this).removeClass('highlight')\});
        #{@javascript_actions}
      });}
    end 
  end
  
  def ajax_success
    @ajax_success ||= render( :partial => File.join(@template, 'ajax_success.js'), :locals => {:pile => self, :p => self})    
  end
  
  def ajax_url
    grid_url({:controller => "bento/#{@element_class}".tableize})
  end

  def message
    @message ||= [ 'bento/shared/message', { :locals => { :pile => self, :p => self } } ]
  end
  
  def default_action(proc)
    @default_action = proc
  end

  def get_default_action
    @default_action
  end
  
  def get_relation
    @relation
  end

  def get_columns
    @columns
  end
  
  def get_element_class
    @element_class
  end
  
  def get_id
    @id
  end
  
  def get_options
    @options
  end
  
  def to_html
    if @options[:ajax]
      body
    else
      super
    end
  end
  
  def body
    @body ||= render( :partial => @template_body, :locals => {:pile => self, :p => self})    
  end
  
end
