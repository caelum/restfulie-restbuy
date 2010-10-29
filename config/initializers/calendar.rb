require 'icalendar'
require 'date'

class Links
  def initialize(h)
    @links = h
  end
  def to_s
    @links.inject("") do |content, link|
      content + "\n<a href=\"#{link[1]}\" rel=\"#{link[0]}\">#{link[0]}</a>"
    end
  end
end