class OrdersController < ApplicationController

  # GET /orders/1
  def show
    @order = Order.find(params[:id])
    @payment = Payment.new

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # POST /orders
  def create
    @order = Order.new
    @order.address = params[:order][:address]
    @order.state = "unpaid"
    @order.save
    if params[:order][:product]
      @order.items.create :product => Product.find(params[:order][:product]), :quantity => params[:order][:quantity]
    end
    session[:order] = @order

    respond_to do |format|
      format.html { redirect_to(@order, :notice => 'Order was successfully created.') }
      format.xml  { render :status => 201, :location => order_url(@order), :xml => @order }
    end
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
      redirect_to(orders_url)
    else
      redirect_to(order, :notice => 'Order can not be cancelled')
    end
  end
end
