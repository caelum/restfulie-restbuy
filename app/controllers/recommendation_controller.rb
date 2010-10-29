class RecommendationController < ApplicationController
  
  respond_to :html
  
  def show
      @order = Order.find(params[:order_id])
      @recommendations = Product.all
      respond_with @recommendations
  end

end
