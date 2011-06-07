module BentoBox
  module Component
    module Sortable

      def init_sortable(objects)
        @element_class ||= objects.klass
        sort_objects(objects)
      end

      def sort_objects(objects)
        column = sort_column
        direction = sort_direction
        order_string = "#{column} #{direction}"
        objects = Object.const_defined?(:BentoBox, :Mongo) ? objects.mongoid_order(order_string) : objects.order(order_string)
      end

      def sortable?
        @sortable
      end

      def sortable(column, title = nil, options={})
        column         = column.to_s
        current_column = sort_column
        css_class      = column == current_column ? "active #{sort_direction} #{options[:class]}" : options[:class]
        direction      = column == current_column && sort_direction == "asc" ? "desc" : "asc"
        link_to({sort_symbol => column, direction_symbol => direction}, { :id => column, :class => css_class, :remote => true }) do
          %{#{title} <span class="arrow"></span>}.html_safe
        end
      end

      def sort_column
        @element_class.column_names.include?(params[sort_symbol]) ? params[sort_symbol] :  @element_class.column_names[0]
      end

      def sort_direction
        %w[asc desc].include?(params[direction_symbol]) ? params[direction_symbol] : "asc"
      end

      def direction_symbol
        @direction_symbol ||= "#{@element_class.to_s.underscore}_direction".to_sym
      end

      def sort_symbol
        @sort_symbol ||= "#{@element_class.to_s.underscore}_sort".to_sym
      end

      def sortable_ajax
        @sortable_ajax ||= render(:partial => '/bento/shared/components/ajax/sortable_ajax', :locals => {:pile => self, :p => self})
      end
    end
  end
end
