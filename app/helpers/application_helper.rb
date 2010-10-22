module ApplicationHelper
  
  
  def current_order
    session[:order]
  end
end
