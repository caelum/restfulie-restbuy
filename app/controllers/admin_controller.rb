class AdminController < ApplicationController
  def index
    @payments = Payment.all
    @orders = Order.all
  end

  def update_payment
    p = Payment.find(params[:id])
    p.state = params[:state]
    p.save
    puts p.state
    puts "state"
    puts p.state.class
    if p.state=="paid"
      o = Order.find(p.order.id)
      if o.completely_paid?
        o.state = "preparing"
        o.save
      end
    end
    redirect_to :action => :index
  end

end
