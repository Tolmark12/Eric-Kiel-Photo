class Bento::PortfoliosController < Bento::BentoController
  # GET /bento/portfolios
  # GET /bento/portfolios.xml
  def index
    @portfolios = Portfolio.scoped

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @portfolios }
    end
  end

  # GET /bento/portfolios/1
  # GET /bento/portfolios/1.xml
  def show
    @portfolio = Portfolio.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @portfolio }
      format.json { with_format(:html) do render('show', :layout => 'bento_json') end  }
    end
  end

  # GET /bento/portfolios/new
  # GET /bento/portfolios/new.xml
  def new
    @portfolio = Portfolio.new()
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @portfolio }
      format.json { with_format(:html) do render('new', :layout => 'bento_json') end  }
    end
  end

  # GET /bento/portfolios/1/edit
  def edit
    @portfolio = Portfolio.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.json { with_format(:html) do render('edit', :layout => 'bento_json') end  }
    end
  end

  # POST /bento/portfolios
  # POST /bento/portfolios.xml
  def create
    @portfolio = Portfolio.new(params[:portfolio])
    respond_to do |format|
      if @portfolio.save
        @respond_type = :success
        @message = 'Portfolio was successfully created.'
        format.js   { render 'bento/shared/message'}
        format.html { redirect_to(bento_portfolios_url, :notice => @message) }
        format.xml  { render :xml => @portfolio, :status => :created, :location => @portfolio }
      else
        @respond_type = :error
      	@message = "Portfolio was not created. #{@portfolio.errors.join(' ')}"
        format.js   { render 'bento/shared/message'}
        format.html { render :action => "new", :error => @message }
        format.xml  { render :xml => @portfolio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bento/portfolios/1
  # PUT /bento/portfolios/1.xml
  def update
    @portfolio = Portfolio.find(params[:id])
    @portfolio.portfolio_item_ids = []
    respond_to do |format|
      if @portfolio.update_attributes(params[:portfolio])
        @respond_type = :success
        @message = 'Portfolio was successfully updated.'
        format.js   { render 'bento/shared/message'}
        format.html { redirect_to(bento_portfolio_url(@portfolio), :notice => @message) }
        format.xml  { head :ok }
      else
        @respond_type = :error
      	@message = "Portfolio was not updated. #{@portfolio.errors.join(' ')}"
        format.js   { render 'bento/shared/message'}
        format.html { render :action => "edit", :error => @message }
        format.xml  { render :xml => @portfolio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bento/portfolios/1
  # DELETE /bento/portfolios/1.xml
  def destroy
    @portfolio = Portfolio.find(params[:id])
    @portfolio.destroy

    respond_to do |format|
      format.html { redirect_to(bento_portfolios_url, :notice => 'Portfolio was successfully deleted.') }
      format.xml  { head :ok }
    end
  end

  def grid
    @portfolios = Portfolio.where({:type => 'Portfolio'})
    with_format(:html) { render '_grid', :layout => 'bento_json', :locals => {:body_only => true} }
  end

end
