
BentoBox::Menu.map do
  item :dashboard, :label => 'Dashboard', :to => {:controller => 'bento/dashboard', :action => 'index'}, :priority => 0
  item :admin, :label => 'Admin', :priority => 1000 do
    #item :bento_users, :label => 'Bento users', :to => { :controller => 'bento/bento_users', :action => 'index'}
    item :config_settings, :label => 'Config Settings',:to => {:controller => 'bento/config_settings', :action => 'index'}
    item :roles, :label => 'Roles',:to => {:controller => 'bento/roles', :action => 'index'}
  end
  item :navs, :label => 'Navs', :to => { :controller => 'bento/navs', :action => 'index'}, :priority => 1 do
    item :nav_items, :label => 'Nav items', :to => { :controller => 'bento/nav_items', :action => 'index'}, :priority => 1
  end
  item :portfolios, :label => 'Portfolios', :to => { :controller => 'bento/portfolios', :action => 'index'}, :priority => 2 do
    item :portfolio_items, :label => 'Portfolio items', :to => { :controller => 'bento/portfolio_items', :action => 'index'}, :priority => 1
  end
  
  item :stock_configs, :label => 'Stock Photos', :to => { :controller => 'bento/stock_configs', :action => 'index'}, :priority => 3 do
    item :stockphotos, :label => 'Stock Photos', :to => { :controller => 'bento/stockphotos', :action => 'index'}, :priority => 1    
    item :stock_default_categories, :label => 'Stock Categories', :to => { :controller => 'bento/stock_default_categories', :action => 'index'}, :priority => 2    
    item :form_definitions, :label => 'Form Definitions', :to => { :controller => 'bento/form_definitions', :action => 'index'}, :priority => 3 do
      item :form_definitions, :label => 'Form Fields', :to => { :controller => 'bento/form_fields', :action => 'index'}, :priority => 1      
    end  
  end

  item :tags, :label => 'Tags', :to => { :controller => 'bento/tags', :action => 'index'}, :priority => 4

end