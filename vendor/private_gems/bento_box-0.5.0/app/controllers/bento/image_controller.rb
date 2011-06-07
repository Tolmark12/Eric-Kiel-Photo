class Bento::ImageController < Bento::BentoController
  require 'base64'
  require 'yaml'
  require 'aws/s3'
  
  
  include AWS::S3

  before_filter :establish_connection
  
  def upload
    params[:file].tempfile.open
    data = params[:file].tempfile.read
    params[:file].tempfile.close
    S3Object.store(params[:qqfile], data, s3_yaml[Rails.env]['bucket'], :access => :public_read)
    sizes          = params[:sizes]  ? params[:sizes].split(',')  : []
    fields         = params[:fields] ? params[:fields].split(',') : []
    size_heights   = params[:size_heights] ? params[:size_heights].split(',') : []
    resized_images = []
    (0..(sizes.size-1)).each { |i|
      size_name   = sizes[i]
      size_height = size_heights[i]
      field       = fields[i]
      bucket      = resize_and_upload(params[:qqfile], size_name, size_height)
      resized_images << %{\{  "size"  : "#{size_name}",
                              "field" : "#{field}",
                              "url"   : "#{S3Object.url_for(params[:qqfile], bucket, :authenticated => false)}"\}}
    }
    if params[:thumbnail] == true then
      bucket = resize_and_upload(params[:qqfile], 'thumb', 250)
    else
      bucket = s3_yaml[Rails.env]['bucket']
    end
    render :json => %{ \{ "success": #{Service.response.success?},"url" : "#{S3Object.url_for(params[:qqfile], bucket, :authenticated => false)}", "other_sizes" : [#{resized_images.join(',')}] \} }
  end
  
  private
  def establish_connection
    Base.establish_connection!(
        :server => 's3.amazonaws.com',
        :access_key_id     => s3_yaml[Rails.env]['access_key_id'],
        :secret_access_key => s3_yaml[Rails.env]['secret_access_key']
    )
  end
  
  def s3_yaml
    @s3_yaml ||= YAML.load_file(Rails.root.join("config", "s3.yml"))
  end
  
  def resize_and_upload(file_name, size_name, height, width=nil)
    type = file_name.gsub(/^(.*)\.(.*)$/, '\2')
    img  = Magick::Image.read(params[:file].tempfile.path) do |info|
      info.format = type
    end
    img = img.first
    if width.nil? then
      width = img.columns * (img.rows/height.to_i)
      width = width.to_i
    end
    img.change_geometry!("#{width}x#{height}") { |cols, rows| img.thumbnail! cols, rows }  
    img.write(params[:file].tempfile.path)    
    params[:file].tempfile.open
    S3Object.store(file_name, params[:file].tempfile, s3_yaml[Rails.env]["bucket_#{size_name}"], :access => :public_read)
    bucket = s3_yaml[Rails.env]["bucket_#{size_name}"]
    params[:file].tempfile.close
    bucket
  end
  
end
