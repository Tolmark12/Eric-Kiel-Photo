module BentoBox
  module Generators
    class ScaffoldGenerator < Rails::Generators::NamedBase
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"
      source_root File.expand_path('../../templates', __FILE__)
      check_class_collision :suffix => "Controller"

      check_class_collision :prefix => "Bento",:suffix => "Controller"

      class_option :orm, :banner => "NAME", :type => :string, :required => true,
                         :desc => "ORM to generate the controller for"

      include Rails::Generators::ResourceHelpers
        
      # A model must exist for us to continue
      def verify_model_exists
        @model_name = name.split('::').last
        # Rails doesn't load classes into memory until called
        # So lets call the class and rescue if it fails
        begin
          Kernel.const_get(@model_name)
        rescue NameError
        end
        
        log :name, name
        
        # If the class isn't defined, lets generate it
        unless Class.const_defined? @model_name
          # Put the attributes back to the way we got them from the command-line
          params = self.attributes.map do |a| 
                                    a = "#{a.name}:#{a.type}" 
                                    a 
                                  end
          # Execute the rails model generator
          generate("model", "#{@model_name} #{params.join(" ")}")
        end
      end
      
      # Add new route under bento namespace
      def add_bento_routes
        routing_code = nested_route([class_path, plural_table_name].flatten)
        log :route, routing_code
        sentinel = /namespace :bento.*do?\s*$/
        in_root do
          inject_into_file 'config/routes.rb', routing_code, { :after => sentinel, :verbose => false }
        end
      end
      
      # Add new public limited route
      def add_limited_public_routes
        routing_code = nested_route([class_path, "#{plural_table_name}, :only => [:index, :show]"].flatten)
        route routing_code
      end

      # Add new menu item
      def add_menu_item
        menu_code = "\n  item :#{plural_table_name}, :label => '#{plural_table_name.humanize}', :to => { :controller => '/#{File.join('bento', class_path, controller_file_name)}', :action => 'index'}\n"
        log :add_menu_item, menu_code
        sentinel = /^end.*$/
        in_root do
          inject_into_file 'config/initializers/bento.rb', menu_code, { :before => sentinel, :verbose => false }
        end
      end
      
      def build_bento_facing
        with_bento_namespace do
          create_bento_controller
          create_bento_helper
          create_view_root_folder
          populate_attributes
          copy_bento_view_files
        end
      end

      def build_public_facing
        unless File.exist?(File.join('app/controllers', class_path, "#{controller_file_name}_controller.rb"))
          create_public_controller
          create_public_helper
          create_view_root_folder
          populate_attributes
          copy_public_view_files
        end        
      end
      
      protected
      
      # Create controller file from template
      def create_public_controller
        template 'controllers/public_controller.rb', File.join('app/controllers', class_path, "#{controller_file_name}_controller.rb")
      end

      # Create controller file from template
      def create_bento_controller
        template 'controllers/bento_controller.rb', File.join('app/controllers', class_path, "#{controller_file_name}_controller.rb")
      end
      
      # Create public helper file from template
      def create_public_helper
        template 'helpers/public_helper.rb', File.join('app/helpers', class_path, "#{controller_file_name}_helper.rb")
      end

      # Create helper file from template
      def create_bento_helper
        template 'helpers/bento_helper.rb', File.join('app/helpers', class_path, "#{controller_file_name}_helper.rb")
      end
      
      # Create view folder
      def create_view_root_folder
        empty_directory File.join("app/views", controller_file_path)
      end

      # If attributes aren't provided, get them from the database
      def populate_attributes
        @connection = ActiveRecord::Base.connection if defined?(ActiveRecord::Base)
        if self.attributes.empty? && @connection
          # Find the primary key field for the table
          if @connection.respond_to?(:pk_and_sequence_for)
            pk, pk_seq = @connection.pk_and_sequence_for(table_name)
          elsif @connection.respond_to?(:primary_key)
            pk = @connection.primary_key(table_name)
          end
          # Add each column to self.attributes as a GeneratedAttribute
          @connection.columns(table_name).each { |column|
            # Ignore the primary key
            self.attributes << Rails::Generators::GeneratedAttribute.new(column.name, column.type) if column.name != pk
          }
        end
      end

      # Create view files from templates
      def copy_public_view_files
        available_public_views.each do |view|
          filename = filename_with_extensions(view)
          template "views/public/#{filename}", File.join('app','views', controller_file_path, filename)
        end
      end

      # Create view files from templates
      def copy_bento_view_files
        available_bento_views.each do |view|
          filename = filename_with_extensions(view)
          template "views/bento/#{filename}", File.join('app','views', controller_file_path, filename)
        end
      end

      def available_public_views
        @available_public_views ||= %w(index show)
      end

      def available_bento_views
        @available_bento_views ||= %w(index edit show new _form _grid)
      end
      
      def filename_with_extensions(file_name)
        file_name = file_name.insert(-1,".html.erb") if not /^.*\.html\.erb$/ =~ file_name
        file_name
      end
      
      def index_helper
        uncountable? ? "#{plural_url_helper}_index" : plural_url_helper
      end
      
      def plural_url_helper
        @plural_url_helper ||= (class_path + [plural_name]).join('_')            
      end

      def singular_url_helper
        @singular_url_helper ||= (class_path + [singular_name]).join('_')
      end
      
      def class_name
        if @class_name.nil?
          # Assign names to not include bento prefix
          assign_names!(self.name.split('::').last)
          @class_name = super
          assign_names!(self.name)
        end
        @class_name
      end
      
      def table_name
        @table_name ||= pluralize_table_names? ? plural_name : singular_name
      end
      
      def with_bento_namespace(&block)
        # Change name to include bento prefix
        self.name = self.name.insert(0,"Bento::") if not self.name.match(/^Bento::.*$/)
        # Assign names to include bento prefix
        clear_file_name_values    
        assign_names!(self.name)
        yield if block_given?
        # Change name to not include bento prefix
        self.name = self.name.gsub(/^Bento::/,'') if self.name.match(/^Bento::.*$/)
        # Assign names to not include bento prefix
        clear_file_name_values      
        assign_names!(self.name)
      end
      
      def clear_file_name_values
        @plural_name = nil
        @singular_name = nil
        @plural_url_helper = nil
        @singular_url_helper = nil
        @class_path = nil
        @controller_file_path = nil
      end
      
      def nested_route(routes, position=0, routes_str="")
        if (routes.count - 1) == position then
          routes_str << "\n    #{"  " * position}resources :#{routes[position]}\n"
          (routes.count - 2).downto(0) do |pos|
            routes_str << "\n    #{"  " * pos}end\n"
          end
          return routes_str
        else
          routes_str << "\n    #{"  " * position}namespace :#{routes[position]} do\n"          
          return nested_route(routes, position+1, routes_str)
        end
      end
    end
  end
end