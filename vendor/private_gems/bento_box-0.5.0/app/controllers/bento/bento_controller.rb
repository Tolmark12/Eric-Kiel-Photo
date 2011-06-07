class Bento::BentoController < ApplicationController
  before_filter :authenticate_bento_user!
  helper_method :message
  layout "bento_box"

  def selector_call
    @object             = (params[:id]) ? eval(params[:object].classify).find(params[:id]) : eval(params[:object].classify).new
    @attribute_relation = eval(params[:attribute].classify).scoped
    
    respond_to do |format|
      format.html {render 'bento/shared/selector'}
      format.json { with_format(:html) { render 'bento/shared/selector', :layout => 'bento_json' }  }
    end

    
  end

  def sorter
    ids          = params[:ids].split(',').map! {|id| {:_id => id}}
    @objects     = eval(params[:object].classify).any_of(ids).order_by([params[:sort_column], params[:sort_direction]]).to_a   
    @parent_name = params[:parent]
    @item_name   = (params[:item_name] || "#{params[:object]}_ids")
    
    with_format(:html) { render 'bento/shared/sorter', :layout => 'bento_json' }
  end

  def with_format(format, &block)
    old_formats  = [self.formats].flatten
    new_formats  = [format,self.formats].flatten
    self.formats = new_formats
    result       = block.call if block_given?
    self.formats = old_formats
    return result
  end
  
  def message(type, text)
  	%{<div style="" class="message #{type.to_s}">
		  <a class="close" href="#link"></a>
		  #{text}
		  <div class="icon"></div>
		</div>
		<div style="display: none;" class="message-small #{type.to_s}-small"></div>}.html_safe
  end

end
