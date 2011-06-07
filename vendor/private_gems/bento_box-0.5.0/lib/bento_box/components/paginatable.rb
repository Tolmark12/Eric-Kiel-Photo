module BentoBox
  module Component
    module Paginatable

      def init_paginatable(objects,object_count,page_number,page_size)
        @element_class ||= objects.klass
        @page_number    = page_number.to_i
        @page_size      = page_size.to_i
        @page_count     = (object_count > 0) ? (objects.count.to_f / @page_size.to_f).ceil.to_i : 1
        paginate_objects(objects)
      end

      def paginatable?
        @paginatable
      end

      def paginate_objects(objects)
        if objects.respond_to?(:paginate) then
          objects.paginate(:page => @page_number, :per_page => @page_size)
        else
          objects = objects.offset(@page_size * (@page_number-1))
          objects.limit(@page_size)
        end
      end

      def first_paginatable(*args)
        paginatable(1, {:title => 'First'}.merge!(args.extract_options!)) if get_page_number > 1
      end

      def last_paginatable(*args)
        paginatable(get_page_count, {:title => 'Last'}.merge!(args.extract_options!)) if get_page_number < get_page_count
      end

      def prev_paginatable(*args)
        paginatable(get_page_number - 1, {:title => 'Previous'}.merge!(args.extract_options!)) if get_page_number > 1
      end

      def next_paginatable(*args)
        paginatable(get_page_number + 1, {:title => 'Next'}.merge!(args.extract_options!))  if get_page_number < get_page_count
      end

      def paginatable(page_number, *args)
        options = args.extract_options!
        (page_number != get_page_number) ? link_to( options[:title] || page_number, {page_symbol => page_number}, 
          { :id => "#{page_string}_#{options[:title] ? options[:title].underscore : page_number}", :class => "#{options[:class]} paginatable", :remote => true }) : options[:title] || page_number if page_number >= 1 && page_number <= get_page_count
      end

      def paginatable_ajax
        @paginatable_ajax ||= render( :partial => '/bento/shared/components/ajax/paginatable_ajax', :locals => {:pile => self, :p => self})
      end

      def get_page_number
        @page_number
      end

      def get_page_count
        @page_count
      end

      def get_page_size
        @page_size
      end

      def page_symbol
        @page_symbol ||= page_string.to_sym
      end

      def page_string
        @page_string ||= (@element_class.nil?) ? 'page'  : "#{@element_class.to_s.underscore}_page"
      end

    end
  end
end
