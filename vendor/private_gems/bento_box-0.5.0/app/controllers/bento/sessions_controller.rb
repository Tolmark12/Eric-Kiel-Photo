class Bento::SessionsController < Devise::SessionsController
  layout "bento_box_login"
  
  def root_path
    bento_home_url
  end
end
