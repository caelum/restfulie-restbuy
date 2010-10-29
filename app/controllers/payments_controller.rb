class PaymentsController < ApplicationController
  
  use_trait {created}
  
  respond_to :html, :xml
  
  def create
    @order = Order.find(params[:order_id])
    @order.state = "processing_payment"
    @order.save
    @order.payments.create params[:payment].merge :state => :processing

    respond_with @order, :status => 201
    
  end

end
