class AdminController < ApplicationController
  def index
    @payments = Payment.all
  end

  def update_payment
    p = Payment.find(params[:id])
    p.state = params[:state]
    p.save
    if p.state=="paid" && p.order.completely_paid?
      p.order.state = "preparing"
    end
    p.order.save
    redirect_to :action => :index
  end

end
