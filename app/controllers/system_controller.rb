class SystemController < ApplicationController
  def logout
    session[:order] = nil
    redirect_to :controller => :products, :action=> :index
  end

end
