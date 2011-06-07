require 'rails'
require 'blockpile/setup'
require 'blockpile/base'

module Blockpile
  class Railtie < Rails::Railtie
    initializer "blockpile.setup default directories" do
      Blockpile.setup do |config|
        config.add_load_path Rails.root.to_s + '/app/helpers'
      end
    end
  end
  
  def self.setup
    yield Blockpile::Setup
  end
  
end