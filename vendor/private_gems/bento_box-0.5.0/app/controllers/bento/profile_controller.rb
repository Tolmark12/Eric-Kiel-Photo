class Bento::ProfileController < Bento::BentoController
  def index
    redirect_to :action => :view
  end

  def view
    respond_to do |format|
      format.html # view.html.erb
      format.xml  { render :xml => current_bento_user }
    end
  end

  def edit
    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => current_bento_user }
    end    
  end
  
  def update
    if current_bento_user.update_with_password(params[:bento_user])
      redirect_to view_bento_profile_url, :notice => :updated
    else
      redirect_to edit_bento_profile_url
    end
  end
  
end