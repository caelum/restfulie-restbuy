class CalendarController < ApplicationController

  include Icalendar

  respond_to :html, :xml, :json, :atom

  # GET /orders/1/calendar
  def show
    @order = Order.find(params[:order_id])

    links = Links.new({
      :order => order_url(@order),
      :payments => order_payments_url(@order),
      :tracking => "http://your_tracking_uri",
      :cancel => order_url(@order)
    })
    
    uri = order_url(@order)
    content = "BEGIN:VCALENDAR
CALSCALE:GREGORIAN
PRODID:iCalendar-Master
VERSION:2.0
BEGIN:VEVENT
DTSTART;VALUE=DATE:20101105
DTEND;VALUE=DATE:20101105
SUMMARY:Buying order #{@order.id}
X-GOOGLE-CALENDAR-CONTENT-TITLE:Buying order #{@order.id}
X-GOOGLE-CALENDAR-CONTENT-ICON:http://www.google.com/calendar/images/google-holiday.gif
X-GOOGLE-CALENDAR-CONTENT-URL:#{order_url(@order)}
X-GOOGLE-CALENDAR-CONTENT-TYPE:text/html
X-GOOGLE-CALENDAR-CONTENT-WIDTH:640
X-GOOGLE-CALENDAR-CONTENT-HEIGHT:480
END:VEVENT
END:VCALENDAR"
    render :text => content
  end

end
