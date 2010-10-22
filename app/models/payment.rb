class Payment < ActiveRecord::Base
  
  belongs_to :order
  
  def finished_processing?
    state != "processing"
  end
end
