# load the libraries
require 'aws'
# log requests using the default rails logger
AWS.config(:logger => Rails.logger)
# load credentials from a file
s3_yaml = YAML.load_file(Rails.root.join("config", "s3.yml"))
AWS.config({:access_key_id     => s3_yaml[Rails.env]['access_key_id'],
            :secret_access_key => s3_yaml[Rails.env]['secret_access_key']})