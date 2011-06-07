class BreadCrumbPile < Blockpile::Base
  def build(trail,object=nil)
    # use this instead of initialize
    @object   = object
    @trail    = trail
    @template = 'bento/shared/components/bread_crumb'
  end
  
  def crumbs
    @crumbs ||= [controller,action].compact
  end
  
  def controller
    @controller ||= {:label => @trail[:controller].humanize, :url => { :controller => @trail[:controller], :action => :index}} unless @trail[:controller] == 'dashboard'
  end
  
  def action
    if @action.nil?
      url      = {:controller => @trail[:controller],:action => action_name}
      name     = nil
      unless @object.nil?
        url[:id] = @object.id
        name     = @object.respond_to?(:name) ? @object.name : (@object.respond_to?(:title)) ? @object.title : @object.id
      end
      @action  = {:label => ( name || @trail[:action].humanize ), :url => url} unless @trail[:action] == 'index'
    end
    @action
  end

  def last
    @last ||= action || controller
  end

end