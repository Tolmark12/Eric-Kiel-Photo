class PagePile < Blockpile::Base

  def toolbar(&block)
    @toolbar = capture(self, &block) if block_given?
  end

  def breadcrumb(&block)
    @breadcrumb = capture(self, &block) if block_given?
  end

  def javascript(&block)
    @javascript = capture(self, &block) if block_given?
  end

  def content(&block)
    @contents = capture(self, &block) if block_given?
  end

  def as_json(options={})
    render_template
    {:toolbar => @toolbar, :breadcrumb => @breadcrumb, :javascript => @javascript, :content => @contents}
  end

  def to_html
    render_template
    content_for :toolbar do
      @toolbar
    end
    content_for :breadcrumb do
      @breadcrumb
    end
    content_for :head do
      javascript_tag do
        @javascript
      end
    end
    @contents
  end

end
