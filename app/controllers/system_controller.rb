class SystemController < ApplicationController
  def logout
    session[:order] = nil
    redirect_to :controller => :products, :action=> :index
    #, :notice => 'Status cleared.'
  end

end
