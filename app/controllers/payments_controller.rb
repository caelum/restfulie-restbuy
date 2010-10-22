class PaymentsController < ApplicationController
  def create
    @order = Order.find(params[:order_id])
    @order.state = "processing_payment"
    @order.save
    @order.payments.create params[:payment].merge :state => :processing
    redirect_to(@order, :notice => 'Payment was successfully created.')
  end

end
