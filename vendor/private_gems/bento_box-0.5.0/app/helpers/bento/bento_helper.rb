module Bento::BentoHelper

  def bread_crumb_trail
    trail = {:controller => controller_name, :action => action_name}
    trail
  end
  
end