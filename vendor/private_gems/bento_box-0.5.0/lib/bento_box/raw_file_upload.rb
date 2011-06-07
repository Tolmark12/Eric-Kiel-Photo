require 'base64'
require 'tempfile'
#
# Usage:
#   place this in your Rails app in the app/metal directory
#
# Based on: http://github.com/newbamboo/example-html5-upload
#
module BentoBox
class RawFileUpload

  def initialize(app)
      @app = app
  end

  def call(env)
    convert_and_pass_on(env) if raw_file_post?(env)
    # now, execute the request using our Rails app
    response = @app.call(env)
  end

  def convert_and_pass_on(env)
    tempfile    = Tempfile.new(env['HTTP_X_FILE_NAME']) 
    tempfile.binmode
    tempfile.write(env['rack.input'].read)
    tempfile.flush
    fake_file = {
      :filename => env['HTTP_X_FILE_NAME'],
      :type => content_type(env['HTTP_X_FILE_NAME']),
      :tempfile => tempfile
    }
    env['rack.request.form_input'] = env['rack.input']
    env['rack.request.form_hash'] ||= {}
    env['rack.request.query_hash'] ||= {}
    env['rack.request.form_hash']['file'] = fake_file
    env['rack.request.query_hash']['file'] = fake_file
    if query_params = env['HTTP_X_QUERY_PARAMS']
      require 'json'
      params = JSON.parse(query_params)
      env['rack.request.form_hash'].merge!(params)
      env['rack.request.query_hash'].merge!(params)
    end
  end

  def raw_file_post?(env)
    env['HTTP_X_FILE_NAME']
  end

  def content_type(filename)
    case type = (filename.to_s.match(/\.(\w+)$/)[1] rescue "octet-stream").downcase
    when %r"jp(e|g|eg)"            then "image/jpeg"
    when %r"tiff?"                 then "image/tiff"
    when %r"png", "gif", "bmp"     then "image/#{type}"
    when "txt"                     then "text/plain"
    when %r"html?"                 then "text/html"
    when "js"                      then "application/js"
    when "csv", "xml", "css"       then "text/#{type}"
    else 'application/octet-stream'
    end
  end
end
end