EricKielPhoto::Application.routes.draw do
  
  resources :coming_soons, :only => [:index, :show]
  resources :config_settings, :only => [:index], :defaults => {:format => :js}
  resources :nav_items, :only => [:index, :show]
  resources :navs, :only => [:index, :show]
  resources :services, :only => [:index, :show]
  resources :stock_configs, :only => [:index], :defaults => {:format => :js}
  resources :subs, :only => [:index, :show]
  resources :tags, :only => [:index, :show]
    
  match "/stockphotos/by_ids/:ids" => "stockphotos#by_ids"
  match "/stockphotos/by_tag/:tag" => "stockphotos#by_tag"
  match "/stock/api/getAllStockTags" => "tags#index"


  match "/selector/:type/:object/:attribute/:label/:destination", :controller => 'bento/bento', :action => 'selector_call', :as => 'selector'

  match "/grid/:controller", :controller => /bento\/.+?/, :action => 'grid', :as => 'grid'

  match "/vladmin/api", :controller => 'config_settings', :action => 'index', :defaults => {:format => :js}

  namespace :bento, :path => "bento" do
    resources :bento_users, :except => [:edit, :update]
    resources :categories
    resources :config_settings, :only => [:index, :update]
    resources :form_definitions
    resources :form_fields
    namespace :image do 
      post :upload
    end
    resources :nav_items
    resources :navs
    resources :portfolios
    resources :portfolio_items
    namespace :profile do 
      get :index
      get  :view
      get  :edit
      put :update
    end
    match '/', :to => 'dashboard#index', :as => "home"
    resources :roles
    resources :stock_configs, :only => [:index, :update]
    resources :stock_default_categories
    resources :stockphotos
    resources :sub_navs
    resources :tags
    
    namespace :seed do 
      get :index
      post :seed
    end
    
    namespace :tags do 
      post :upload
    end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
