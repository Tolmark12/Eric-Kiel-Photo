require 'base64'
require 'yaml'
require 'aws'
require 'net/http'
require 'csv'

namespace :load do
  task :build_buckets => :environment do
    establish_connection
    for bucket in [s3_yaml['production']["bucket"],s3_yaml['production']["bucket_mid"],s3_yaml['production']["bucket_small"],s3_yaml['production']["bucket_thumb"]]
      begin
        puts 'Creating bucket ' + bucket
        s3.buckets.create(bucket)
        puts '... done'
      rescue Exception=>e
        puts e
      end
      s3.buckets.map {|b| puts b.name} 
    end
  end
  task :items => :environment do
    establish_connection
    seed_file  = File.new(Rails.root.join("db", "seeds.txt"), "rb").read
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
  end
  task :tags  => :environment do
    tags_file   = Rails.root.join("db", "stock_photo_tags.tab")
    tag_count   = 0
    photo_count = 0
    CSV.foreach(tags_file,:col_sep => "\t", :headers => true) do |fields|
      photo      = Stockphoto.where({:name => fields[0]}).first
      tag_names  = fields[1].split(';')
      tag_names.each do |tag_name|
        tag_name.strip!
        tag = Tag.where({:name => tag_name}).first
        if tag.nil?
          tag = Tag.new({:text_id => tag_name.underscore, :name => tag_name, :rank => 0})
          tag.save!
        end
        unless photo.nil?
          photo.tag_ids << tag.id
          tag.stockphoto_ids << photo.id
          tag.stockphoto_ids.uniq!
          tag.save
        end
      end
      tag_count  = tag_count + tag_names.count
      unless photo.nil?
        photo_count = photo_count + 1
        photo.tag_ids.uniq!
        photo.save
      end
    end
  end
end

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
        image = fields[3].match(/[^\/]+$/)[0].gsub(/"/, '')
        image_data = nil
        s3_image = s3.buckets[s3_yaml['production']["bucket"]].objects[image]
        unless s3_image.exists? then
          Net::HTTP.start("www.kielphoto.com") { |http|
            image_data = http.get("/media/template#{fields[3].gsub(/"/, '')}").body
            s3_image.write(image_data, {:acl => :public_read})      
          }
        end
        fields[3] = %{"#{s3_image.public_url}"}
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
        image_data = nil
        bucket = case 
                when field == "image"
                  s3_yaml['production']["bucket"]
                when field == "small_image"
                  s3_yaml['production']["bucket_small"]
                else 
                   s3_yaml['production']["bucket_mid"]
                end
          s3_image = s3.buckets[s3_yaml['production']["bucket"]].objects[image]
          unless s3_image.exists? then
            Net::HTTP.start("www.kielphoto.com") { |http|
              image_data = http.get(value).body
              s3_image = s3.buckets[s3_yaml['production']["bucket"]].objects[image]
              s3_image.write(image_data, {:acl => :public_read})      
            }
          end
          fields[3] = %{"#{s3_image.public_url}"}
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

def s3
  @s3 ||= AWS::S3.new  
end

def establish_connection
  AWS.config({
      :server => s3_yaml['url'],
      :access_key_id     => s3_yaml['production']['access_key_id'],
      :secret_access_key => s3_yaml['production']['secret_access_key']
  })
end

def s3_yaml
  @s3_yaml ||= YAML.load_file(Rails.root.join("config", "s3.yml"))
end
