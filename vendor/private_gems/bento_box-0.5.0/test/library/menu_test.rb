require 'rubygems'
require 'active_support'
require 'active_support/test_case'
require 'test/unit'
require 'bento_box/menu'

class MenuTest < ActiveSupport::TestCase
  
  setup do
    BentoBox::Menu.clear
  end

  test 'should add item' do
    BentoBox::Menu.map do
      item :catalog, :to => 'admin/catalog#index'
      item :sales, :to => 'admin/sales#index'
    end
    assert BentoBox::Menu.size == 2
  end
  
  test 'should allow multi-level' do
    BentoBox::Menu.map do
      item :catalog do
        item :products, :to => 'admin/products#index'
        item :categories, :to => 'admin/categories#index'
      end        
    end
    assert BentoBox::Menu.item(:catalog).children.size == 2   
  end
  
  test 'should retain order' do
    BentoBox::Menu.map do
      item :catalog do
        item :products, :to => 'admin/products#index'
        item :categories, :to => 'admin/categories#index'
      end
      item :sales do
        item :invoices, :to => 'admin/invoices#index'
        item :orders, :to => 'admin/orders#index'
      end      
    end
    
    count_i = 0
    assert BentoBox::Menu.items.each_key { |key|
      entry = BentoBox::Menu.items[key]
      if count_i == 0
        assert entry.name == 'catalog'          
      elsif count_i == 1
        assert entry.name == 'sales'          
      end
      count_i += 1
    }
        
  end
=begin  
  test 'should alter order' do
    
    BentoBox::Menu.map do
      item :sales do
        item :invoices, :to => 'admin/invoices#index'
        item :orders, :to => 'admin/orders#index'
      end      
      item :catalog do
        item :products, :to => 'admin/products#index'
        item :categories, :to => 'admin/categories#index'
      end
    end
    
  end
=end
end
