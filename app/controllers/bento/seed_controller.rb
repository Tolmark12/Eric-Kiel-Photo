class Bento::SeedController < Bento::BentoController
  # GET /bento/seed
  # GET /bento/seed.xml
  def index
  end

  def seed
    #main_portfolio   = Portfolio.find('main-photo-portfolio')
    #default_category = Category.find('default-undscr-profile')
    seed_file  = params[:file].read
    seed_count = 0
    lines      = seed_file.split(/[\n|\r]+/)
    lines.delete_at(0)
    obj_id   = -1
    obj_type = 'dummy_class'
    obj      = DummyClass.new
    lines.each do |line|
      fields = line.split(/,/)
      if fields.size == 4 then
        fields.map! { |f| f.strip }
        fields[1] = fields[1].gsub(/"/,'')
        if fields[0].to_i != obj_id  or fields[1] != obj_type then
          obj.save
          obj        = translate(fields[1].gsub(/"/,'')).new
          obj_id     = fields[0].to_i
          obj_type   = fields[1]
          seed_count = seed_count + 1
        end
        handler_map[obj_type].handle(obj, fields) if handler_map[obj_type]
      end
    end
    redirect_to(bento_seed_index_url, :notice => "Seeded #{seed_count} items!") 
  end
  
  private
  def translate(type)
    case type
      when "image" then PortfolioItem
      when "portfolio" then Portfolio
      when "stock_photo" then Stockphoto
      when "stock_default_category" then StockDefaultCategory
      when "form_field" then FormField
      when "form" then FormDefinition
      else DummyClass
    end
  end
  
  def handler_map
    @handler_map ||= {'portfolio' => DefaultHandler, 'image' => PortfolioItemHandler,
                      'stock_photo' => StockPhotoHandler, 'form_field' => DefaultHandler,
                      'form' => DefaultHandler, 'stock_default_category' => PortfolioItemHandler}
  end
  
  
  
  class DefaultHandler
    def self.handle(obj, fields)
      begin
        eval(%{obj.#{fields[2].gsub(/\s+|"/,'')} = #{fields[3]}}) unless fields[2] =~ /tags/
      rescue Exception=>e
        Rails.logger.warn "#{e}: #{fields}"
      end
    end
  end  
  
  class PortfolioItemHandler < DefaultHandler
    def self.handle(obj, fields)
      if fields[2] =~ /video_emved_code/
        fields[2] = "video_embed_code"
        unless fields[3].nil? or fields[3].gsub(/"/,'').empty?
          obj.item_type = 'Video'
        end
      end 
      if fields[2] =~ /src/ then
        fields[3] = "\"http://www.kielphoto.com/media/template#{fields[3].gsub(/^"/, '')}"
      end
      super(obj, fields)
    end
  end

  class StockPhotoHandler < DefaultHandler
    def self.handle(obj, fields)
      if fields[2] =~ /image/ then
        image = fields[3].gsub(/\\|"/,'')
        image_map = {'image' => "/media/stock/comp/#{image}", 'small_image' => "/media/stock/comp/small/#{image}",'mid_image' => "/media/stock/comp/mid/#{image}"}
        image_map.each_pair { |field, value|
          fields[2] = field
          fields[3] = %{"http://www.kielphoto.com#{value}"}
          super(obj, fields)
        }
      else
        super(obj, fields)
      end
    end
  end
  
  class DummyClass
    def save
    end
  end
end