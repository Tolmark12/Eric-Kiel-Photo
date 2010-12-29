 class Bento::StockphotosController < Bento::BentoController
   # GET /bento/stockphotos
   # GET /bento/stockphotos.xml
   def index
     @stockphotos = Stockphoto.scoped

     respond_to do |format|
       format.html # index.html.erb
       format.xml  { render :xml => @stockphotos }
     end
   end

   # GET /bento/stockphotos/1
   # GET /bento/stockphotos/1.xml
   def show
     @stockphoto = Stockphoto.find(params[:id])

     respond_to do |format|
       format.html # show.html.erb
       format.xml  { render :xml => @stockphoto }
       format.json { with_format(:html) do render('show', :layout => 'bento_json') end  }
     end
   end

   # GET /bento/stockphotos/new
   # GET /bento/stockphotos/new.xml
   def new
     @stockphoto = Stockphoto.new()
     respond_to do |format|
       format.html # new.html.erb
       format.xml  { render :xml => @stockphoto }
       format.json { with_format(:html) do render('new', :layout => 'bento_json') end  }
     end
   end

   # GET /bento/stockphotos/1/edit
   def edit
     @stockphoto = Stockphoto.find(params[:id])
     respond_to do |format|
       format.html # edit.html.erb
       format.json { with_format(:html) do render('edit', :layout => 'bento_json') end  }
     end
   end

   # POST /bento/stockphotos
   # POST /bento/stockphotos.xml
   def create
     @stockphoto = Stockphoto.new(params[:stockphoto])

     respond_to do |format|
       if @stockphoto.save
         @respond_type = :success
         @message = 'Stockphoto was successfully created.'
         format.js   { render 'bento/shared/message'}
         format.html { redirect_to(bento_stockphotos_url, :notice => @message) }
         format.xml  { render :xml => @stockphoto, :status => :created, :location => @stockphoto }
       else
         @respond_type = :error
       	 @message = "Stockphoto was not created. #{@stockphoto.errors.join(' ')}"
         format.js   { render 'bento/shared/message'}
         format.html { render :action => "new", :error => @message }
         format.xml  { render :xml => @stockphoto.errors, :status => :unprocessable_entity }
       end
     end
   end

   # PUT /bento/stockphotos/1
   # PUT /bento/stockphotos/1.xml
   def update
     @stockphoto = Stockphoto.find(params[:id])

     respond_to do |format|
       if @stockphoto.update_attributes(params[:stockphoto])
         @respond_type = :success
         @message = 'Stockphoto was successfully updated.'
         format.js   { render 'bento/shared/message'}
         format.html { redirect_to(bento_stockphoto_url(@stockphoto), :notice => @message) }
         format.xml  { head :ok }
       else
         @respond_type = :error
       	 @message = "Stockphoto was not updated. #{@stockphoto.errors.join(' ')}"
         format.js   { render 'bento/shared/message'}
         format.html { render :action => "edit", :error => @message }
         format.xml  { render :xml => @stockphoto.errors, :status => :unprocessable_entity }
       end
     end
   end

   # DELETE /bento/stockphotos/1
   # DELETE /bento/stockphotos/1.xml
   def destroy
     @stockphoto = Stockphoto.find(params[:id])
     @stockphoto.destroy

     respond_to do |format|
       format.html { redirect_to(bento_stockphotos_url, :notice => 'Stockphoto was successfully deleted.') }
       format.xml  { head :ok }
     end
   end

   def grid
     @stockphotos = Stockphoto.scoped
     with_format(:html) { render '_grid', :layout => 'bento_json', :locals => {:body_only => true} }
   end

 end
 