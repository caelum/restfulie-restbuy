class AdminController < ApplicationController
  def index
    @payments = Payment.all
  end

  def update_payment
  end

end
