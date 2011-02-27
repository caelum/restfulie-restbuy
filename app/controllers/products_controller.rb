require 'relata/dsl'

class ProductsController < ApplicationController
  
  use_trait {created; save_prior_to_create; }
  
  respond_to :html, :atom, :json, :xml

  def index
    query = params[:q] || ''
    @products = Product.where(:name).like?("%#{query}%")
    respond_with @products
  end

  def show
    @product = Product.find(params[:id])
    respond_with @product
  end

  def new
    @product = Product.new
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create
    @product = Product.new(params[:product])
    respond_with @product, :status => 201
  end

  def update
    @product = Product.find(params[:id])

    if @product.update_attributes(params[:product])
      redirect_to(@product, :notice => 'Product was successfully updated.')
    else
      render :action => "edit"
    end
  end

end
