class MenuPile < Blockpile::Base

  def build(menu_items)
    # use this instead of initialize
    @menu_items = menu_items.values.sort { |a,b| (a.priority || 1) <=> (b.priority || 1) }
    @template = 'bento/shared/components/menu'
  end
  
  def menu_items
    @menu_items
  end
    
end