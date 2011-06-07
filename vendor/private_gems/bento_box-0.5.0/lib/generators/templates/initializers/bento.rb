
BentoBox::Menu.map do
  item :dashboard, :label => 'Dashboard', :to => {:controller => '/bento/dashboard', :action => 'index'}, :priority => 0
  item :admin, :label => 'Admin', :priority => 1000 do
    item :bento_users, :label => 'Bento users', :to => { :controller => '/bento/bento_users', :action => 'index'}
    item :roles, :label => 'Roles',:to => {:controller => '/bento/roles', :action => 'index'}
  end
end