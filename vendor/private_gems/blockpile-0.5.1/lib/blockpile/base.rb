class Blockpile::Base
  
  def initialize(helper, *args, &block)
    @helper = helper
    build *args
    @content = capture(self, &block) if block_given?
  end
  
  def to_html
    render_template
  end
  
  def to_json(*args)
    self.as_json.to_json(*args)
  end
  
  def as_json
    {:content => render_template}
  end
  
  def get_content
    @content
  end
  
  def build
    # override this method to build your block
  end
  
protected
  
  def quoted_value(value)
    value.is_a?(String) ? "\"#{value}\"" : value 
  end
  
  # Assumes /views/helper/ as base
  def render_template
    @rendered_template ||= render(:partial => @template, :locals => {:pile => self, :p => self})
  end
  
  def method_missing(*args, &block)
    @helper.send(*args, &block)
  end
  
  def with_format(format, &block)
    old_format = params[:format]
    params[:format] = format
    yield if block_given?
    params[:format] = old_format
  end
  
end
