require "bento_box"

module BentoBox
  module Menu
    class Item
      attr_accessor :children, :to, :name, :label, :priority
      
      def initialize(name, label, to, priority)
        super
        @name = name
        @label = label
        @to = to
        @priority = priority
        @children = {}
      end
      
      def item(name="",options={},&block)
        item = Item.new(name.to_s, (options[:label]||name.to_s), options[:to], options[:priority])
        children[name.to_sym] = item
        if block_given?
          item.instance_eval(&block)
        end
        item
      end
      
    end
    
    @menu = Item.new("menu","","",0)
    
    def self.map(*args,&block)
      if block_given?
        @menu.instance_eval(&block)
      end
    end
    
    def self.items
      @menu.children
    end
    
    def self.item(symbol)
      @menu.children[symbol]
    end
    
    def self.clear
      @menu = nil
      @menu = Item.new("menu","","",0)      
    end

    def self.size
      @menu.children.size
    end
    
    def self.menu
      @menu
    end
    private
  end
end