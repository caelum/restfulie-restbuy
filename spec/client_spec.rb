require 'spec_helper'

describe Restfulie do

  context "when searching" do

    def search(what)
      description = Restfulie.at("http://localhost:3000/products/opensearch.xml").accepts('application/opensearchdescription+xml').get.resource
      items = description.use("application/xml").search(:searchTerms => what, :startPage => 1)
    end


    it "should be able to search items" do
      items = search("20")
      items.resource.products.size.should == 2
    end

    def paid_order
      {:order => { :address=> "jdfkjdk", :state => "paid"}}
    end

    def my_order
      { :order => {:address => "R. Vergueiro 3185, Sao Paulo, Brazil"} }
    end

    it "should be able to create an empty order" do
      response = search("20")
      response = response.resource.products.links.order.follow.post(my_order)
      response.resource.order.address.should == my_order[:order][:address]
    end

    it "should be able to add an item to an order" do
      results = search("20")

      product = results.resource.products.product[0]
      selected = {:order => {:product => product.id, :quantity => 1}}

      result = results.resource.products.links.order.follow.post(my_order).resource
      result = result.order.links.self.follow.put(selected).resource

      result.order.price.should == product.price

    end

    it "should be able to pay" do
      results = search("20")

      product = results.resource.products.product[0]
      selected = {:order => {:product => product.id, :quantity => 1}}

      result = results.resource.products.links.order.follow.post(my_order).resource
      result = result.order.links.self.follow.put(selected).resource

      result = pay(result)
      result.order.state.should == "processing_payment"

    end

    def pay(result)
      card = {:payment => {:card_holder => "guilherme silveira", :card_number => 4444, :value => result.order.price}}
      result = result.order.links.payment.follow.post(card).resource
    end

    def wait_payment_success(attempts, result)

      response = search("20")
      result.order.state = "paid"
      response = response.resource.products.links.order.follow.post(result.order)
      #response.resource.order.address.should == paid_order[:order][:address]

      if result.order.state == "processing_payment"

        puts "Checking order status at #{result.order.links.self.href}"
        result = result.order.links.self.follow.get.resource
      end

      if result.order.state == "unpaid" && attempts>0
        puts "Ugh! Payment rejected! Get some credits my boy... I am trying it again."
        result = pay(result)
        wait_payment_success(attempts-1, result)
      else
        result
      end 
    end

    it "should try and pay for it" do
      results = search("20")

      product = results.resource.products[0]
      selected = {:order => {:product => product.id, :quantity => 1}}

      result = results.resource.products.links.order.follow.post(my_order).resource
      result = result.order.links.self.follow.put(selected).resource

      result = pay(result)

      result = wait_payment_success(1, result)
      result.order.state.should == "paid"

    end

  end


end