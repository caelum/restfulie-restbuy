class Order < ActiveRecord::Base

  has_many :items
  has_many :payments
  
  def completely_paid?
    price_to_pay <= 0
  end
  
  def state
    return super if completely_paid?
    return "processing_payment" if is_processing_payment?
    return "partially_paid" if paid > 0
    return "unpaid"
  end
  
  def is_processing_payment?
    payments.detect do |p|
      p.state == "processing"
    end
  end
  
  def price
    items.inject(0) do |sum, i|
      sum + i.product.price
    end
  end
  
  def price_to_pay
    price - paid
  end
  
  def paid
    payments.inject(0) do |sum, p|
      sum + (p.state=="paid" ? p.value : 0)
    end
  end
  
  def can_pay?
    !completely_paid?
  end
  
end
