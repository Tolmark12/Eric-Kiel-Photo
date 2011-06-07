require 'blockpile'
require 'devise'
require 'RMagick'
require 'bento_box'
require 'rails'
require 'bento_box/raw_file_upload'

module BentoBox
 class Engine < Rails::Engine
   initializer "Handle raw posts" do |app|
         app.middleware.use BentoBox::RawFileUpload
   end
   initializer "bentobox.setup blockpile paths" do
     Blockpile.setup do |config|
       config.add_load_path File.dirname(__FILE__) + "/../../app/helpers"
     end
   end
 end
end