module Blockpile
  module Setup
    def self.add_load_path(path)
      Dir.glob(path + "/**/*_pile.rb") do |file|
        ActiveSupport::Dependencies.autoload_paths << File.dirname(file)
        file_name   = file.split(/\//).pop.gsub(/\.rb/, '')
        class_name  = file_name.classify
        pile_methods =  %{
          def #{file_name.gsub(/\_pile/, '')}(*args, &block)
            blockpile = #{class_name}.new(self, *args, &block)
            blockpile.to_html
          end
          
          def #{file_name.gsub(/\_pile/, '')}_instance(*args, &block)
            #{class_name}.new(self, *args, &block)
          end
        }
        ActionView::Base.class_eval pile_methods
        ActionController::Base.class_eval %{delegate :#{file_name.gsub(/\_pile/, '')}, :#{file_name.gsub(/\_pile/, '')}_instance,:to => :view_context}
      end
    end
  end
end