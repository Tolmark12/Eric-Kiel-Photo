source 'http://rubygems.org'

gem 'rails', '3.2.1'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem "mongoid", ">=2.4.0"
gem "bson_ext"

gem "dalli"

gem 'blockpile', :path => 'vendor/private_gems/blockpile-0.5.1' #:git => 'git@github.com:tylerflint/blockpile.git'
gem 'bento_box', :path => 'vendor/private_gems/bento_box-0.5.0' #:git => 'git@github.com:Tolmark12/bento.git'
gem 'bento_box_mongo', :path => 'vendor/private_gems/bento_box_mongo-0.0.2'  #:git => 'git@github.com:Tolmark12/bento-mongoid.git'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
group :production do
  gem 'thin'
end