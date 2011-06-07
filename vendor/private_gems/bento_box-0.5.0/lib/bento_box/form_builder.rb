# These methods are added to the FormHelper
require 'aws/s3'

module BentoBox
  class FormBuilder < ActionView::Helpers::FormBuilder
    include AWS::S3
    include ActionView::Helpers::UrlHelper
    
    def fields_for(record_or_name_or_array, *args, &block)
      super(record_or_name_or_array, *args, :builder => BentoBox::FormBuilder, &block)
    end

    def selector(relation, *args)
      options            = args.extract_options!
      object_class_str   = (options[:object] || object.class.to_s.underscore)
      relation_singular  = relation.to_s.singularize
      relation_object    = eval(relation_singular.classify)
      options[:label]   ||= relation_object.respond_to?(:name) ? :name : relation_object.respond_to?(:title) ? :title : :id
      
      selector_tag = link_to("",%{#{Rails.application.routes.url_helpers.bento_selector_path(:type => (options[:type] || "default"), :object => object_class_str, 
                  :attribute => relation_singular, :label => options[:label], :is_label_image => options[:is_label_image],
                  :id => object.id, :orderable => options[:orderable],
                  :destination => "#{object_class_str}-#{relation.to_s}")}},
                                  :rel =>"address:/#{relation_singular}", :class => "selector-link")
      selector_tag << @template.submit_tag("Select #{relation.to_s.titleize}", :class => 'button-thin select-items', :onclick => '$(this).prev("a.selector-link").click(); return false;')
      selector_tag << "<div id='#{object_class_str}-#{relation.to_s}'>".html_safe
      object.send(relation).each do |action|
        selector_tag << @template.hidden_field("#{@object_name}[#{relation_singular}_ids]", '', objectify_options({:id => "#{relation_singular}_#{action.id}",:value => action.id}))
      end
      selector_tag << "</div>".html_safe
      selector_tag.html_safe
    end

    def image_uploader(method, options={})
      img_src = object.send(method)
      
      image_upload_tag = "<div>".html_safe
      image_upload_tag << @template.hidden_field(@object_name, method.to_s, objectify_options({:value => img_src, :class => 'base'}))
      
      values = {:resize_fields => [], :resize_names => [], :resize_heights => []} if options[:resize]
      
      (options[:resize] || {}).each_pair { |size, opts|
        resize_field = opts[:field] || size
        resize_src   = object.send(resize_field)
        image_upload_tag << @template.hidden_field(@object_name, resize_field.to_s, objectify_options({:value => resize_src, :class => resize_field}))
        values[:resize_fields] << resize_field.to_s
        values[:resize_names] << size.to_s
        values[:resize_heights] << opts[:height]
      }
      unless img_src.nil? or img_src.empty?
        if options[:thumbnail] then
          establish_connection unless options[:thumbnail_path]
          img_src = options[:thumbnail_path] ? "#{options[:thumbnail_path]}/#{img_src}" : S3Object.url_for(img_src, s3_yaml[Rails.env]['bucket_thumb'], :authenticated => false)
        end
        image_upload_tag << "<img src='#{img_src}' height='100' />".html_safe
      end
      thumb = ''
      if options[:thumbnail] then
        thumb = 'thumbnail'
      end
      image_upload_tag << "<div id='#{method.to_s}' class='image-uploader #{thumb}' >".html_safe
      image_upload_tag << "<span class='sizes'>#{values[:resize_names].join(',')}</span><span class='fields'>#{values[:resize_fields].join(',')}</span><span class='size_heights'>#{values[:resize_heights].join(',')}</span>".html_safe if values      
      image_upload_tag << "</div></div>".html_safe
      image_upload_tag
    end
    
    private 
    
    def s3_yaml
      @s3_yaml ||= YAML.load_file( Rails.root.join("config", "s3.yml"))
    end

    def establish_connection
      Base.establish_connection!(
          :server => 's3.amazonaws.com',
          :access_key_id     => s3_yaml[Rails.env]['access_key_id'],
          :secret_access_key => s3_yaml[Rails.env]['secret_access_key']
      )
    end

  end
end
