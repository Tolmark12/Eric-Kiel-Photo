module BentoBox
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("../../templates", __FILE__)

       # Implement the required interface for Rails::Generators::Migration.
       # taken from http://github.com/rails/rails/blob/master/activerecord/lib/generators/active_record.rb
      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          Time.now.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end
         
      def initialize(*runtime_args)
        super(*runtime_args)
      end

      def add_routes
        route %{namespace :bento, :path => "bento" do
    resources :bento_users, :except => [:edit, :update]
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
  end}
        route %{match "/grid/:controller", :controller => /bento\\/.+?/, :action => 'grid', :as => 'grid'}
        route %{match "/selector/:type/:object/:attribute/:label/:destination", :controller => 'bento/bento', :action => 'selector_call', :as => 'selector'}
      end
      
      def create_migration_files
        migration_template "migrations/bento_users_migration.rb", "db/migrate/devise_create_bento_users.rb"
        sleep(1)
        migration_template "migrations/mother_migration.rb", "db/migrate/create_mother_tables.rb"
        puts "Current login is 'admin' with password 'password'. It is HIGHLY recommended that you change that you these settings immediately!"
      end

      def create_initializers
        copy_file "initializers/bento.rb", "config/initializers/bento.rb"
      end

      def install_devise
        gem("devise")
        generate("devise:install")
      end
      
      def create_locales
        copy_file "locales/devise.en.yml", "config/locales/bento.devise.en.yml"       
      end
      
      def create_skin
        rake("bento:skin:install")
      end

    end
  end
end