module BentoBox
  if defined?(Rails)
    require 'rubygems'
    require 'bento_box/components/sortable'
    require 'bento_box/components/filterable'
    require 'bento_box/components/paginatable'
    require 'bento_box/form_builder' 
    require 'bento_box/menu' 
    require 'bento_box/tempfile_ext' 
    require 'bento_box/raw_file_upload' 
    require 'bento_box/engine' 
  end
end