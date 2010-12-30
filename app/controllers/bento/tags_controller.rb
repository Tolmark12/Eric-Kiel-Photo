class Bento::TagsController < Bento::BentoController
  # GET /bento/tags
  # GET /bento/tags.xml
  def index
    @tags = Tag.scoped

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tags }
    end
  end

  # GET /bento/tags/1
  # GET /bento/tags/1.xml
  def show
    @tag = Tag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tag }
      format.json { with_format(:html) do render('show', :layout => 'bento_json') end  }
    end
  end

  # GET /bento/tags/new
  # GET /bento/tags/new.xml
  def new
    @tag = Tag.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tag }
      format.json { with_format(:html) do render('new', :layout => 'bento_json') end  }
    end
  end

  # GET /bento/tags/1/edit
  def edit
    @tag = Tag.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.json { with_format(:html) do render('edit', :layout => 'bento_json') end  }
    end
  end

  # POST /bento/tags
  # POST /bento/tags.xml
  def create
    @tag = Tag.new(params[:tag])

    respond_to do |format|
      if @tag.save
        @respond_type = :success
        @message = 'Tag was successfully created.'
        format.js   { render 'bento/shared/message'}
        format.html { redirect_to(bento_tags_url, :notice => @message) }
        format.xml  { render :xml => @tag, :status => :created, :location => @tag }
      else
        @respond_type = :error
      	@message = "Tag was not created. #{@tag.errors.join(' ')}"
        format.js   { render 'bento/shared/message'}
        format.html { render :action => "new", :error => @message }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # POST /bento/upload
  def upload
    tags_file   = params[:file].read
    tag_count   = 0
    photo_count = 0
    lines       = tags_file.split(/\r/)
    lines.delete_at(0)
    lines.each do |line|
      fields     = line.split(/\t/)
      photo      = Stockphoto.where({:name => fields[0]}).first
      tag_names  = fields[1].split(';')
      tag_names.each do |tag_name|
        tag_name.strip!
        tag = Tag.where({:name => tag_name}).first
        if tag.nil?
          tag = Tag.new({:text_id => tag_name.underscore, :name => tag_name, :rank => 0})
          tag.save!
        end
        photo.tag_ids << tag.id unless photo.nil?    
      end
      tag_count  = tag_count + tag_names.count
      unless photo.nil?
        photo_count = photo_count + 1
        puts "Photo: #{photo}"
        puts "Photo Tags: #{photo.tag_ids}"
        photo.save
      end
    end
    redirect_to(bento_tags_url, :notice => "#{tag_count} tags uploaded! Tags added to #{photo_count} photos!") 
  end
  
  # PUT /bento/tags/1
  # PUT /bento/tags/1.xml
  def update
    @tag = Tag.find(params[:id])

    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        @respond_type = :success
        @message = 'Tag was successfully updated.'
        format.js   { render 'bento/shared/message'}
        format.html { redirect_to(bento_tag_url(@tag), :notice => @message) }
        format.xml  { head :ok }
      else
        @respond_type = :error
      	@message = "Tag was not updated. #{@tag.errors.join(' ')}"
        format.js   { render 'bento/shared/message'}
        format.html { render :action => "edit", :error => @message }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bento/tags/1
  # DELETE /bento/tags/1.xml
  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to(bento_tags_url, :notice => 'Tag was successfully deleted.') }
      format.xml  { head :ok }
    end
  end

  def grid
    @tags = Tag.scoped
    render :partial => 'grid', :layout => false, :locals => {:body_only => true}
  end

end
