# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper  
  def is_admin?
    if logged_in? 
      current_user.admin == true
    else
      false
    end
  end
  
  def user_has_permission?(event)
    current_user.id == event.user_id || is_admin?
  end
  
  def redirect_to_index(msg = "You do not have permissions to access this object.")
    flash[:notice] = msg
    redirect_to :action => 'index'
  end
  
  def redirect_back_or(path)
    redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to path
  end
  
  def draw_map(map, width, height)
    return map.to_html, map.div(:width => width, :height => height)     
  end

end
 
