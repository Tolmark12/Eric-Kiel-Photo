Rails.application.routes.draw do   
  match "/grid/:controller", :controller => /bento\/.+?/, :action => 'grid', :as => 'grid'
  
  namespace :bento do
    resources :bento_users, :except => [:edit, :update]
    match "/selector/:object/:attribute/:type/:label/:destination", :controller =>  'bento', :action => 'selector_call', :as => 'selector'
    match "/sorter/:parent/:object/:sort_column/:sort_direction/:ids", :controller =>  'bento', :action => 'sorter', :as => 'sorter'

    namespace :image do 
      post :upload
    end

    namespace :profile do 
      get :index
      get  :view
      get  :edit
      put :update
    end

    match '/', :to => 'dashboard#index', :as => "home"

    resources :roles
  end
  
  devise_for :bento_users, :path => 'bento', :controllers => { :sessions => "bento/sessions" }
end