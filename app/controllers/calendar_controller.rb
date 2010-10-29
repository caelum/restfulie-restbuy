class CalendarController < ApplicationController

  include Icalendar

  respond_to :html, :xml, :json, :atom

  # GET /orders/1/calendar
  def show
    @order = Order.find(params[:order_id])
    
    cal = Calendar.new
      order = @order
      @order.items.each do |item|
      cal.event do
        dtstart       Date.new(2010, 11, 05)
        dtend         Date.new(2010, 11, 06)
        summary     "Delivery #{item.product.name}."
        description "The product should be delivered today."
        klass       "PRIVATE"
      end
    end

    render :text => cal.to_ical
  end

end
