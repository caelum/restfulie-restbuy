class AdminController < ApplicationController
  def index
    @payments = Payment.all
    @orders = Order.all
  end

  def update_payment
    p = Payment.find(params[:id])
    p.state = params[:state]
    p.save
    if p.state=="paid"
      o = Order.find(p.order.id)
      if o.completely_paid?
        o.state = "preparing"
        o.save
      end
    end
    redirect_to :action => :index
  end

  def update_order
    o = Order.find(params[:id])
    o.state = params[:state]
    o.save
    redirect_to :action => :index
  end

end
