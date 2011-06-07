class ContainerPile < Blockpile::Base
  def build(*args)
    @columns = (1..args.size).to_a
    @ratios = []
    args.each { |col|
      @ratios << col
    }
    (1..@ratios.size).to_a.each { |col_index|
      class_eval %{
        define_method(:col_#{col_index.to_s}) do |&block|
          @columns[#{col_index-1}] = capture(&block) 
        end
        define_method(:get_col_#{col_index}) do 
          @columns[#{col_index-1}]
        end
      }
    }
    @center_index = @columns.size/2
    @template = 'bento/shared/containers/container'
  end
  
  def left(&block)
    @columns[0] = capture(&block)
  end
  
  def center(&block)
    @columns[@center_index] = capture(&block)  
  end

  def right(&block)
    @columns[-1] = capture(&block)  
  end
  
  def get_left
    @columns[0]
  end
  
  def get_center
    @columns[@center_index]
  end
  
  def get_right
    @columns[-1]
  end
  
end