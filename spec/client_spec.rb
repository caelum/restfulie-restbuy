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
      
      card = {:payment => {:card_holder => "guilherme silveira", :card_number => 4444, :value => result.order.price}}
      result = result.order.links.payment.follow.post(card).resource
      result.order.state.should == "processing_payment"

    end
    
    def wait_for_order_state(state, result, do_what)
      while result.order.state != "preparing"
        sleep 10
        puts "Checking order status at #{result.order.links.self.href}, please #{do_what}"
        result = result.order.refresh.resource
      end
      result
    end
    
    it "should wait until its preparing" do
      description = Restfulie.at("http://localhost:3000/products/opensearch.xml").accepts('application/opensearchdescription+xml').get.resource
      results = description.use("application/atom+xml").search(:searchTerms => "20", :startPage => 1)
      
      product = results.resource.entries[0]
      selected = {:order => {:product => product.id, :quantity => 1}}

      result = results.resource.links.order.follow.post(my_order).resource
      result = result.order.links.self.follow.put(selected).resource
      
      card = {:payment => {:card_holder => "guilherme silveira", :card_number => 4444, :value => result.order.price}}
      result = result.order.links.payment.follow.post(card).resource
      
      result = wait_for_order_state "preparing", result, "confirm its payment as paid."
      result.order.state.should == "preparing"

    end

  end


end