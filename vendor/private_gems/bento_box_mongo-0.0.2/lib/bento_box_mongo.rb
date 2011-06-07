require 'mongoid'
module BentoBox
  module Mongo
    require 'rubygems'
    require 'bento_box_mongo/engine'
    require 'bento_box_mongo/alias'
    require 'bento_box_mongo/bento_document'
    Mongoid::Document.class_eval do
      def self.included(base)
        base.extend BentoBox::Mongo::BentoDocument
      end
    end
  end
end