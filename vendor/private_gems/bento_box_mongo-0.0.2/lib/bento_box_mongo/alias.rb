module BentoBox
  module Mongo
    module Alias
      extend ActiveSupport::Concern
      included do
        class << self
          alias :aliased_field :field
          alias :field :alias_field
        end
        alias :filtered_process :process
        alias :process :filter_process
      end
      
            
      def filter_process(attrs = nil)
        unless attrs.nil?
          self.class.field_aliases.each_pair do |key, value|
            attrs[key] = attrs[value] unless attrs[value].nil?
          end
        end
        filtered_process(attrs)
      end
      
      module ClassMethods
        def field_aliases
          @field_aliases ||= {}
        end

        def alias_field(field, *args)
          options = args.extract_options!
          field_alias = options[:alias] || options[:store_as]
          send("aliased_field", field, options)
          if field_alias then
            self.class_eval("alias :#{field_alias} :#{field}")
            self.class_eval("alias :#{field_alias}= :#{field}=")
            field_aliases[field] = options[:alias] || options[:store_as]
          end
        end
      end
      
    end
  end
end