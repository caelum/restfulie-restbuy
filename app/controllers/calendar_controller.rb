class CalendarController < ApplicationController

  include Icalendar

  respond_to :html, :xml, :json, :atom

  # GET /orders/1/calendar
  def show
    @order = Order.find(params[:order_id])
    
    links = []
    links << ["", order_url(@order)]
    links << ["payments", order_payments_url(@order)]
    links << ["tracking", "http://your_tracking_uri"]
    links << ["cancel", order_url(@order)]
    def links.to_s
      inject("") do |content, link|
        content + "\n<a href=\"#{link[1]}\" rel=\"#{link[0]}\">#{link[0]}</a>"
      end
    end
    
    cal = Calendar.new
      order = @order
      @order.items.each do |item|
      cal.event do
        dtstart       Date.new(2010, 11, 05)
        dtend         Date.new(2010, 11, 06)
        summary     "Delivery #{item.product.name}."
        description "The product should be delivered today. #{links.to_s}"
        klass       "PRIVATE"
      end
    end

    render :text => cal.to_ical
  end

end
