require 'spec_helper'

describe Restfulie do
  
  context "when searching" do
    
    it "should be able to search items" do
      description = Restfulie.at("http://localhost:3000/products/opensearch.xml").accepts('application/opensearchdescription+xml').get.resource
      items = description.use("application/atom+xml").search(:searchTerms => "20", :startPage => 1)
      items.resource.entries.size.should == 2
    end
    
    def my_order
      { :order => {:address => "R. Vergueiro 3185, Sao Paulo, Brazil"} }
    end
    
    it "should be able to create an empty order" do
      description = Restfulie.at("http://localhost:3000/products/opensearch.xml").accepts('application/opensearchdescription+xml').get.resource
      response = description.use("application/atom+xml").search(:searchTerms => "20", :startPage => 1)
      response = response.resource.links.order.follow.post(my_order)
      response.resource.order.address.should == my_order[:order][:address]
    end
    
    it "should be able to add an item to an order" do
      description = Restfulie.at("http://localhost:3000/products/opensearch.xml").accepts('application/opensearchdescription+xml').get.resource
      results = description.use("application/atom+xml").search(:searchTerms => "20", :startPage => 1)
      
      product = results.resource.entries[0]
      selected = {:order => {:product => product.id, :quantity => 1}}

      result = results.resource.links.order.follow.post(my_order).resource
      result = result.order.links.self.follow.put(selected).resource
      result.order.price.should == product.price
      
    end
    
    it "should be able to pay" do
      description = Restfulie.at("http://localhost:3000/products/opensearch.xml").accepts('application/opensearchdescription+xml').get.resource
      results = description.use("application/atom+xml").search(:searchTerms => "20", :startPage => 1)
      
      product = results.resource.entries[0]
      selected = {:order => {:product => product.id, :quantity => 1}}

      result = results.resource.links.order.follow.post(my_order).resource
      result = result.order.links.self.follow.put(selected).resource
      
      result = pay(result)
      result.order.state.should == "processing_payment"

    end
    
    def pay(result)
      card = {:payment => {:card_holder => "guilherme silveira", :card_number => 4444, :value => result.order.price}}
      result = result.order.links.payment.follow.post(card).resource
    end
    
    def wait_payment_success(attempts, result)
      if attempts==0
        return result
      end
      
      while result.order.state == "processing_payment"
        sleep 10
        puts "Checking order status at #{result.order.links.self.href}"
        result = result.order.refresh.resource
      end
      
      if result.order.state == "unpaid"
        puts "Ugh! Payment rejected! Get some credits my boy... I am trying it again."
        result = pay(result)
        wait_payment_success(attempts-1, result)
      else
        result
      end
    end
    
    it "should wait until its delivering" do
      description = Restfulie.at("http://localhost:3000/products/opensearch.xml").accepts('application/opensearchdescription+xml').get.resource
      results = description.use("application/atom+xml").search(:searchTerms => "20", :startPage => 1)
      
      product = results.resource.entries[0]
      selected = {:order => {:product => product.id, :quantity => 1}}

      result = results.resource.links.order.follow.post(my_order).resource
      result = result.order.links.self.follow.put(selected).resource

      result = pay(result)
      
      result = wait_payment_success(2, result)
      result.order.state.should == "preparing"

    end

  end


end