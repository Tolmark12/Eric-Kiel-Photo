module BentoBox
  module Mongo
    module BentoDocument
      def scoped 
        self.criteria
      end
      
      def columns
        self.fields.values
      end

      def columns_hash
        self.fields
      end

      def column_names
        self.fields.keys
      end
      
      def order(order_stmt)
        orders = order_stmt.to_s.split(',')
        orders.map!{|order| order.split.map{|o| o.to_sym} }
        self.order_by(*orders)
      end
      alias_method :mongoid_order, :order
    end
  end
end