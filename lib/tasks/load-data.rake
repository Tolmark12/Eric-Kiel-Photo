require 'base64'
require 'yaml'
require 'aws/s3'
require 'net/http'

include AWS::S3

namespace :load do
  task :build_buckets => :environment do
    establish_connection
    for bucket in [s3_yaml['production']["bucket"],s3_yaml['production']["bucket_mid"],s3_yaml['production']["bucket_small"],s3_yaml['production']["bucket_thumb"]]
      begin
        Bucket.create(bucket)
      rescue
        nil
      end
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
      aws_repeat {
        image = fields[3].match(/[^\/]+$/)[0]
        image_data = nil
        Net::HTTP.start("www.kielphoto.com") { |http|
          image_data = http.get("/media/template#{fields[3].gsub(/^"/, '')}").body
          S3Object.store(image, image_data, s3_yaml['production']["bucket"], :access => :public_read)      
        }
        fields[3] = %{"#{S3Object.url_for(image, bucket, :authenticated => false)}"}
      }
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
        aws_repeat {
          Net::HTTP.start("www.kielphoto.com") { |http|
            image_data = http.get(value).body
            bucket = case 
                    when field == "image"
                      s3_yaml['production']["bucket"]
                    when field == "small_image"
                      s3_yaml['production']["bucket_small"]
                    else 
                       s3_yaml['production']["bucket_mid"]
                    end
            S3Object.store(image, image_data, bucket, :access => :public_read)
          }
          fields[3] = %{"#{S3Object.url_for(image, bucket, :authenticated => false)}"}
        }
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

def aws_repeat(description = nil)
  # Calls the block up to 3 times, allowing for AWS connection reset problems
  for i in 1..3
    begin
      yield
    rescue Errno::ECONNRESET => e
      ok = false
      ActiveRecord::Base.logger.error \
           "AWS::S3 *** Errno::ECONNRESET => sleeping"
      sleep(1)
      if i == 1
        # reset connection
        establish_connection # re-login in to AWS
        ActiveRecord::Base.logger.error \
           "AWS::S3 *** Errno::ECONNRESET => reset connection"
      end        
    else
      ok = true
      break
    end
  end

  unless ok
    msg = "AWS::S3 *** FAILURE #{description.to_s}"
    ActiveRecord::Base.logger.error msg
  end

  ok
end

def establish_connection
  puts s3_yaml['production']['access_key_id']
  puts s3_yaml['production']['secret_access_key']
  Base.establish_connection!(
      :server => 's3.amazonaws.com',
      :access_key_id     => s3_yaml['production']['access_key_id'],
      :secret_access_key => s3_yaml['production']['secret_access_key']
  )
end

def s3_yaml
  @s3_yaml ||= YAML.load_file(Rails.root.join("config", "s3.yml"))
end
