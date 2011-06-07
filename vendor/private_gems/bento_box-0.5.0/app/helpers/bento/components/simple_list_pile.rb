class SimpleListPile < Blockpile::Base
  def build(title, *elements)
    @title = title
    @elements = elements.flatten
    @template = 'bento/shared/components/simple_list'
  end
  
  def get_elements
    @elements
  end
  
  def get_title
    @title
  end

end