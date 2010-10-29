class CalendarController < ApplicationController

  respond_to :html, :xml, :json, :atom
  
  def time_format(t)
    t.strftime("%Y%m%d")
  end

  # GET /orders/1/calendar
  def show
    @order = Order.find(params[:order_id])

    links = Links.new({
      :order => order_url(@order),
      :payments => order_payments_url(@order),
      :tracking => "http://your_tracking_uri",
      :cancel => order_url(@order)
    })
    
    content = "BEGIN:VCALENDAR
CALSCALE:GREGORIAN
PRODID:iCalendar-Master
VERSION:2.0
BEGIN:VEVENT
DTSTART;VALUE=DATE:#{time_format(@order.expected_delivery)}
DTEND;VALUE=DATE:#{time_format(@order.expected_delivery)}
SUMMARY:Delivering order #{@order.id}
X-GOOGLE-CALENDAR-CONTENT-TITLE:Buying order #{@order.id}
X-GOOGLE-CALENDAR-CONTENT-ICON:http://www.google.com/calendar/images/google-holiday.gif
X-GOOGLE-CALENDAR-CONTENT-URL:#{order_url(@order)}
X-GOOGLE-CALENDAR-CONTENT-TYPE:text/html
X-GOOGLE-CALENDAR-CONTENT-WIDTH:640
X-GOOGLE-CALENDAR-CONTENT-HEIGHT:480
END:VEVENT
BEGIN:VEVENT
DTSTART;VALUE=DATE:#{time_format(@order.expected_delivery+2.days)}
DTEND;VALUE=DATE:#{time_format(@order.expected_delivery+2.days)}
SUMMARY:Recommended products
X-GOOGLE-CALENDAR-CONTENT-TITLE:Recommended products
X-GOOGLE-CALENDAR-CONTENT-ICON:#{url_for("/images/recommended.png")}
X-GOOGLE-CALENDAR-CONTENT-URL:#{order_recommendation_url(@order)}
X-GOOGLE-CALENDAR-CONTENT-TYPE:text/html
X-GOOGLE-CALENDAR-CONTENT-WIDTH:640
X-GOOGLE-CALENDAR-CONTENT-HEIGHT:480
END:VEVENT
END:VCALENDAR"
    render :text => content
  end

end
