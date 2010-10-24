class PaymentsController < ApplicationController
  def create
    @order = Order.find(params[:order_id])
    @order.state = "processing_payment"
    @order.save
    @order.payments.create params[:payment].merge :state => :processing

    debugger
    respond_to do |format|
      format.html { redirect_to(@order, :notice => 'Payment was successfully created.') }
      format.xml  { render :status => 201, :location => order_url(@order), :text => "" }
    end
    
  end

end
