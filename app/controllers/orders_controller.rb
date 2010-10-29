class OrdersController < ApplicationController
  
  use_trait {cacheable; created}

  respond_to :html, :xml, :json, :atom

  # GET /orders/1
  def show
    @order = Order.find(params[:id])
    @payment = Payment.new
    respond_with @order, :expires_in => 0.seconds
  end

  # POST /orders
  def create
    @order = Order.new
    @order.expected_delivery = Time.now + 3.days
    @order.address = params[:order][:address]
    @order.state = "unpaid"
    @order.save
    if params[:order][:product]
      @order.items.create :product => Product.find(params[:order][:product]), :quantity => params[:order][:quantity]
    end
    session[:order] = @order
    respond_with @order, :status => 201
  end

  # PUT /orders/1
  def update
    @order = Order.find(params[:id])
    @order.items.create :product => Product.find(params[:order][:product]), :quantity => params[:order][:quantity]
    session[:order] = @order
    redirect_to(@order, :notice => 'Order was successfully updated.')
  end

  # DELETE /orders/1
  def destroy
    @order = Order.find(params[:id])
    if @order.can_cancel?
      @order.state = "cancelled"
      @order.save
      respond_to do |format|
        format.html { redirect_to(orders_url) }
        format.xml  { redirect_to(order_url(@order)) }
      end
    else
      redirect_to(order, :notice => 'Order can not be cancelled')
    end
  end
end
