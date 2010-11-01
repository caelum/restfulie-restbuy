class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.xml
  def index
    @orders = Order.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.xml
  def show
    @order = Order.find(params[:id])
    @payment = Payment.new

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # POST /orders
  # POST /orders.xml
  def create
    @order = Order.new
    @order.address = params[:order][:address]
    @order.state = "unpaid"
    @order.save
    @order.items.create :product => Product.find(params[:order][:product]), :quantity => params[:order][:quantity]
    session[:order] = @order

    redirect_to(@order, :notice => 'Order was successfully created.')
  end

  # PUT /orders/1
  # PUT /orders/1.xml
  def update
    @order = Order.find(params[:id])
    @order.items.create :product => Product.find(params[:order][:product]), :quantity => params[:order][:quantity]
    session[:order] = @order
    redirect_to(@order, :notice => 'Order was successfully updated.')
  end

  # DELETE /orders/1
  # DELETE /orders/1.xml
  def destroy
    @order = Order.find(params[:id])
    if @order.can_cancel?
      @order.state = "cancelled"
      @order.save
      respond_to do |format|
        format.html { redirect_to products_url, :notice => "Order cancelled." }
        format.xml  { redirect_to(order_url(@order)) }
      end
    else
      redirect_to(order, :notice => 'Order can not be cancelled')
    end
  end
end
