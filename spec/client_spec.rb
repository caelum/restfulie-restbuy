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
    
  end

end