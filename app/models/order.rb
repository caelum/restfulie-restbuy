class Order < ActiveRecord::Base

  has_many :items
  
end
