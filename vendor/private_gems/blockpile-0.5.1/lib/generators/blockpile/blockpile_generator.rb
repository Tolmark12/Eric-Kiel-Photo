class BlockpileGenerator < Rails::Generators::NamedBase
  
  source_root File.expand_path('../templates', __FILE__)
  
  def generate
    template "blockpile.rb", "app/helpers/#{file_name}_pile.rb"
    copy_file "blockpile.html.erb", "app/views/shared/_#{file_name}.html.erb"
  end
  
  protected
  
  def file_name
    name.underscore
  end
  
  def class_name
    name.classify
  end
  
end