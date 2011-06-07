module BentoBox
  module Component
    module Filterable

      def init_filterable(objects)
        @element_class ||= objects.klass
        filter_objects(objects)
      end

      def filterable?
        @filterable
      end

      def filter_objects(objects)
        filter   = params[filter_symbol] || {}
        filter.each_pair { |key, value|
          column_name = (key.to_s.gsub(/\_range\_begin$|\_range\_end$/, ''))
          if key.to_s.match(/^.*\_range\_begin$/) then
            objects = objects.where(where_range_clause(@element_class.columns_hash[column_name.to_s],value, filter["#{column_name}_range_end".to_sym]))            
          elsif !@element_class.columns_hash[column_name.to_s].nil? && !key.to_s.match(/^.*\_range\_end$/) then
            e = @element_class.new
            objects = objects.where(where_clause(@element_class.columns_hash[column_name.to_s],value, !(defined?(ActiveRecord::Base) && e.is_a?(ActiveRecord::Base))))
          end
        }
        objects
      end

      def filterable(column_name)
        column = @element_class.columns_hash[column_name.to_s]
        filter_tag = nil
        unless column.nil?
          if [:string, :text, :integer, :float, :decimal].include?((column.type.is_a?(Symbol)) ? column.type : column.type.to_s.downcase.to_sym)
            filter_tag = text_field_tag("#{filter_string}[#{column_name.to_s}]")
          elsif [:datetime, :timestamp, :time, :date].include?((column.type.is_a?(Symbol)) ? column.type : column.type.to_s.downcase.to_sym)
            filter_tag = raw("<a class='calendar-icon' href='#link'></a><a href='#link'>Select Date Range</a>")
          end
        end
        filter_tag
      end

      def filterable_ajax
        @filterable_ajax ||= render( :partial => '/bento/shared/components/ajax/filterable_ajax', :locals => {:pile => self, :p => self})
      end

      private

      def where_clause(column, value, is_mongoid=false)
        where_clause = {}
        unless value.nil? or value == ''
          if [:string, :text].include?((column.type.is_a?(Symbol)) ? column.type : column.type.to_s.downcase.to_sym) then
            where_clause = is_mongoid ? { column.name => /#{Regexp.escape(value)}/i} : " #{column.name} LIKE '%#{value}%'"
          elsif [:integer, :float, :decimal].include?((column.type.is_a?(Symbol)) ? column.type : column.type.to_s.downcase.to_sym) then
            where_clause = { column.name => value }
          elsif [:datetime, :timestamp, :time, :date].include?((column.type.is_a?(Symbol)) ? column.type : column.type.to_s.downcase.to_sym) then
            where_clause = { column.name => DateTime.strptime(value, "%m/%d/%Y").to_time }
          end
        end
        where_clause
      end

      def where_range_clause(column,begin_value, end_value)
        where_clause = {}
        unless begin_value.nil? or begin_value == ''
          if [:integer, :float, :decimal].include?((column.type.is_a?(Symbol)) ? column.type : column.type.to_s.downcase.to_sym) then
            where_clause = { column.name => begin_value..(end_value || 9999999999)}
          elsif [:datetime, :timestamp, :time, :date].include?((column.type.is_a?(Symbol)) ? column.type : column.type.to_s.downcase.to_sym) then
            where_clause = { column.name => DateTime.strptime(begin_value, "%m/%d/%Y").to_time..DateTime.strptime((end_value || DateTime.end_of_day), "%m/%d/%Y").to_time }
          end
        end
        where_clause
      end

      def filter_symbol
        @filter_symbol ||= filter_string.to_sym
      end

      def filter_string
        @filter_string ||= (@element_class.nil?) ? 'filter'  : "#{@element_class.to_s.underscore}_filter"
      end

    end
  end
end
